# frozen_string_literal: true

require_relative '../base_tool'

class FrontListEventOccurrenceWaitlistEligibilities < Pike13BaseTool
  description "Check waitlist eligibility"

  input_schema(
    properties: {
      event_occurrence_id: { type: 'integer', description: 'Unique Pike13 event occurrence ID (integer)' }
    },
    required: ['event_occurrence_id']
  )

  class << self
    def call(event_occurrence_id:, server_context:)
      Pike13::Front::EventOccurrenceWaitlistEligibility.all(event_occurrence_id: event_occurrence_id).to_json
    end
  end
end
