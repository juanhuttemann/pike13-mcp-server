# frozen_string_literal: true

require_relative '../base_tool'

class DeskListEventOccurrenceVisits < Pike13BaseTool
  description "List event occurrence visits"

  input_schema(
    properties: {
      event_occurrence_id: { type: 'integer', description: 'Unique Pike13 event occurrence ID (integer)' }
    },
    required: ['event_occurrence_id']
  )

  class << self
    def call(event_occurrence_id:, server_context:)
      Pike13::Desk::EventOccurrenceVisit.all(event_occurrence_id: event_occurrence_id).to_json
    end
  end
end
