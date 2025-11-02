# frozen_string_literal: true

require_relative '../base_tool'

class FrontGetWaitlistEntry < Pike13BaseTool
  description <<~DESC
    Get customer waitlist entry by ID.

    Returns waitlist entry details: person, event_occurrence (name/start_at/end_at/service/location),
    and state (pending/waiting/enrolled/removed/expired).

    States: pending (spot reserved during signup), waiting (default, waiting for spot),
    enrolled (enrolled from waitlist), removed (removed from waitlist), expired (class completed while waiting).

    Only returns entries for authenticated customer or dependents.

    Use to show customers their waitlist status.
  DESC

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
  description <<~DESC
    Add person to waitlist for full event.

    Creates waitlist entry for authenticated person or dependent.
    Person defaults to authenticated user if not specified.

    Returns created entry with person, event_occurrence, and state.

    Use to allow customers to join waitlist for full classes.
  DESC

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
  description <<~DESC
    Remove person from waitlist.

    Deletes the waitlist entry, removing person from waitlist.

    Use to allow customers to cancel their waitlist position.
  DESC

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
