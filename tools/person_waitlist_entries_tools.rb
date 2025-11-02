# frozen_string_literal: true

require_relative 'base_tool'

class DeskListPersonWaitlistEntries < Pike13BaseTool
  description <<~DESC
    List all waitlist entries for a person.
    Returns array of waitlist entry objects with event occurrence details, position, timestamp, notification status, and expiration.
    Use for managing customer waitlists, checking waitlist status, or customer service inquiries.
  DESC

  input_schema(
    properties: {
      person_id: { type: 'integer', description: 'Unique Pike13 person ID (integer)' }
    },
    required: ['person_id']
  )

  class << self
    def call(person_id:, server_context:)
      Pike13::Desk::PersonWaitlistEntry.all(person_id: person_id).to_json
    end
  end
end

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
