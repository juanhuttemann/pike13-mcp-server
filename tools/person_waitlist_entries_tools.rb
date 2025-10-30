# frozen_string_literal: true

require_relative 'base_tool'

class DeskListPersonWaitlistEntries < Pike13BaseTool
  description <<~DESC
    [STAFF] List all waitlist entries for a person.
    Returns array of waitlist entry objects with event occurrence details, position, timestamp, notification status, and expiration.
    Use for managing customer waitlists, checking waitlist status, or customer service inquiries.
  DESC

  arguments do
    required(:person_id).filled(:integer).description('Unique Pike13 person ID (integer)')
  end

  def call(person_id:)
    Pike13::Desk::PersonWaitlistEntry.all(person_id: person_id).to_json
  end
end

class FrontListPersonWaitlistEntries < Pike13BaseTool
  description <<~DESC
    [CLIENT] List customer own waitlist entries.
    Returns array of customer-visible waitlist entries with class details, position, and estimated availability.
    Use for customer self-service waitlist viewing.
  DESC

  arguments do
    required(:person_id).filled(:integer).description('Unique Pike13 person ID (integer)')
  end

  def call(person_id:)
    Pike13::Front::PersonWaitlistEntry.all(person_id: person_id).to_json
  end
end
