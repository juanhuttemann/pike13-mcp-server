# frozen_string_literal: true

require_relative '../base_tool'

class FrontGetWaitlistEntry < Pike13BaseTool
  description "Get waitlist entry"

  input_schema(
    properties: {
      entry_id: { type: 'integer', description: 'Unique Pike13 waitlist entry ID' }
    },
    required: ['entry_id']
  )

  class << self
    def call(entry_id:, server_context:)
      Pike13::Front::WaitlistEntry.find(entry_id).to_json
    end
  end
end

class FrontCreateWaitlistEntry < Pike13BaseTool
  description "Join waitlist"

  input_schema(
    properties: {
      event_occurrence_id: { type: 'integer', description: 'Event occurrence ID to join waitlist for' },
      person_id: { type: 'integer', description: 'Optional: person ID (defaults to authenticated person)' }
    },
    required: ['event_occurrence_id']
  )

  class << self
    def call(event_occurrence_id:, server_context:, person_id: nil)
      params = { event_occurrence_id: event_occurrence_id }
      params[:person_id] = person_id if person_id
      Pike13::Front::WaitlistEntry.create(params).to_json
    end
  end
end

class FrontDeleteWaitlistEntry < Pike13BaseTool
  description "Leave waitlist"

  input_schema(
    properties: {
      entry_id: { type: 'integer', description: 'Waitlist entry ID to delete' }
    },
    required: ['entry_id']
  )

  class << self
    def call(entry_id:, server_context:)
      Pike13::Front::WaitlistEntry.delete(entry_id).to_json
    end
  end
end
