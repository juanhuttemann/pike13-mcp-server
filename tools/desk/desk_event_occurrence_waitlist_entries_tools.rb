# frozen_string_literal: true

require_relative '../base_tool'

class DeskListEventOccurrenceWaitlistEntries < Pike13BaseTool
  description "List event occurrence waitlist entries"

  input_schema(
    properties: {
      event_occurrence_id: { type: 'integer', description: 'Unique Pike13 event occurrence ID (integer)' }
    },
    required: ['event_occurrence_id']
  )

  class << self
    def call(event_occurrence_id:, server_context:)
      Pike13::Desk::EventOccurrenceWaitlistEntry.all(event_occurrence_id: event_occurrence_id).to_json
    end
  end
end
