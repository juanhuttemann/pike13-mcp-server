# frozen_string_literal: true

require_relative '../base_tool'

class FrontListPersonWaitlistEntries < Pike13BaseTool
  description <<~DESC
    List customer own waitlist entries.
    Returns array of customer-visible waitlist entries with class details, position, and estimated availability.
    Use for customer self-service waitlist viewing.
  DESC

  input_schema(
    properties: {
      person_id: { type: 'integer', description: 'Unique Pike13 person ID (integer)' }
    },
    required: ['person_id']
  )

  class << self
    def call(person_id:, server_context:)
      Pike13::Front::PersonWaitlistEntry.all(person_id: person_id).to_json
    end
  end
end
