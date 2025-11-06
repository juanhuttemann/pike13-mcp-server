# frozen_string_literal: true

require_relative '../base_tool'

class DeskListVisits < Pike13BaseTool
  description "List visits"

  input_schema(
    properties: {
      person_id: { type: 'integer', description: 'Person ID filter' }
    },
    required: []
  )

  class << self
    def call(server_context:, person_id: nil)
      visits = person_id ? Pike13::Desk::Visit.all(person_id: person_id) : Pike13::Desk::Visit.all
      visits.to_json
    end
  end
end

class DeskGetVisit < Pike13BaseTool
  description "Get visit"

  input_schema(
    properties: {
      visit_id: { type: 'integer', description: 'Visit ID' }
    },
    required: ['visit_id']
  )

  class << self
    def call(visit_id:, server_context:)
      Pike13::Desk::Visit.find(visit_id).to_json
    end
  end
end

class DeskCreateVisit < Pike13BaseTool
  description "Create visit"

  input_schema(
    properties: {
      event_occurrence_id: { type: 'integer', description: 'Event occurrence ID' },
      person_id: { type: 'integer', description: 'Person ID (required unless reserved)' },
      state: { type: 'string', description: 'State: reserved/registered/completed/noshowed/late_canceled' },
      notify_client: { type: 'boolean', description: 'Notify client' },
      restrictions: { type: 'array', description: 'Restrictions: inside_blackout_window/full/in_the_past' }
    },
    required: ['event_occurrence_id']
  )

  class << self
    def call(event_occurrence_id:, server_context:, person_id: nil, state: nil, notify_client: nil, restrictions: nil)
      params = { event_occurrence_id: event_occurrence_id }
      params[:person_id] = person_id if person_id
      params[:state] = state if state
      params[:notify_client] = notify_client unless notify_client.nil?
      params[:restrictions] = restrictions if restrictions
      Pike13::Desk::Visit.create(params).to_json
    end
  end
end

class DeskUpdateVisit < Pike13BaseTool
  description "Update visit"

  input_schema(
    properties: {
      visit_id: { type: 'integer', description: 'Visit ID' },
      state_event: { type: 'string', description: 'State transition: register/complete/noshow/late_cancel/reset' },
      person_id: { type: 'integer', description: 'Person ID (for register only)' }
    },
    required: ['visit_id']
  )

  class << self
    def call(visit_id:, server_context:, state_event: nil, person_id: nil)
      params = {}
      params[:state_event] = state_event if state_event
      params[:person_id] = person_id if person_id
      Pike13::Desk::Visit.update(visit_id, params).to_json
    end
  end
end

class DeskDeleteVisit < Pike13BaseTool
  description "Delete visit"

  input_schema(
    properties: {
      visit_id: { type: 'integer', description: 'Visit ID' },
      notify_client: { type: 'boolean', description: 'Notify client' },
      remove_recurring_enrollment: { type: 'boolean', description: 'Remove future recurring visits' }
    },
    required: ['visit_id']
  )

  class << self
    def call(visit_id:, server_context:, notify_client: nil, remove_recurring_enrollment: nil)
      params = {}
      params[:notify_client] = notify_client unless notify_client.nil?
      params[:remove_recurring_enrollment] = remove_recurring_enrollment if remove_recurring_enrollment
      Pike13::Desk::Visit.destroy(visit_id, **params).to_json
    end
  end
end
