# frozen_string_literal: true

require_relative '../base_tool'

class FrontListVisits < Pike13BaseTool
  description "List visits"

  class << self
    def call(server_context:)
      Pike13::Front::Visit.all.to_json
    end
  end
end

class FrontGetVisit < Pike13BaseTool
  description "Get visit"

  input_schema(
    properties: {
      visit_id: { type: 'integer', description: 'Visit ID' }
    },
    required: ['visit_id']
  )

  class << self
    def call(visit_id:, server_context:)
      Pike13::Front::Visit.find(visit_id).to_json
    end
  end
end

class FrontCreateVisit < Pike13BaseTool
  description "Create visit"

  input_schema(
    properties: {
      event_occurrence_id: { type: 'integer', description: 'Event occurrence ID to enroll in' },
      person_id: { type: 'integer', description: 'Optional: person ID (defaults to authenticated person)' }
    },
    required: ['event_occurrence_id']
  )

  class << self
    def call(event_occurrence_id:, server_context:, person_id: nil)
      params = { event_occurrence_id: event_occurrence_id }
      params[:person_id] = person_id if person_id
      Pike13::Front::Visit.create(params).to_json
    end
  end
end

class FrontDeleteVisit < Pike13BaseTool
  description "Cancel visit"

  input_schema(
    properties: {
      visit_id: { type: 'integer', description: 'Visit ID to cancel' },
      remove_recurring_enrollment: { type: 'boolean',
                                     description: 'Optional: remove future recurring visits (boolean, default false)' }
    },
    required: ['visit_id']
  )

  class << self
    def call(visit_id:, server_context:, remove_recurring_enrollment: nil)
      params = {}
      params[:remove_recurring_enrollment] = remove_recurring_enrollment if remove_recurring_enrollment
      Pike13::Front::Visit.destroy(visit_id, **params).to_json
    end
  end
end
