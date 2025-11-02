# frozen_string_literal: true

require_relative 'base_tool'

class DeskListEventOccurrenceWaitlistEntries < Pike13BaseTool
  description <<~DESC
    List all waitlist entries for an event occurrence (class session).
    Returns array of waitlist entry objects with person details, position, timestamp, and notification status.
    Use for managing class waitlists, notifying customers when spots open, or capacity planning.
  DESC

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

class FrontListEventOccurrenceWaitlistEligibilities < Pike13BaseTool
  description <<~DESC
    Check customer waitlist eligibility for an event occurrence (class session).
    Returns eligibility information including whether customer can join waitlist, eligibility reasons, and restrictions.
    Use before allowing customer to join waitlist.
  DESC

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
