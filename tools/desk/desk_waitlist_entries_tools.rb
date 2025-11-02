# frozen_string_literal: true

require_relative '../base_tool'

class DeskListWaitlistEntries < Pike13BaseTool
  description <<~DESC
    [STAFF] List all waitlist entries.

    Returns waitlist entries with person, event_occurrence, state, and timestamps (created_at/updated_at).

    Use for waitlist management, filling open spots, or understanding demand for full classes.
  DESC

  class << self
    def call(server_context:)
      Pike13::Desk::WaitlistEntry.all.to_json
    end
  end
end

class DeskGetWaitlistEntry < Pike13BaseTool
  description <<~DESC
    [STAFF] Get waitlist entry details by ID.

    Returns complete waitlist entry: person, event_occurrence, state, created_at, and updated_at.

    States: pending (spot reserved), waiting (default), enrolled (moved to roster),
    removed (removed from waitlist), expired (class completed).

    Use for waitlist management or customer service inquiries.
  DESC

  input_schema(
    properties: {
      entry_id: { type: 'integer', description: 'Unique Pike13 waitlist entry ID' }
    },
    required: ['entry_id']
  )

  class << self
    def call(entry_id:, server_context:)
      Pike13::Desk::WaitlistEntry.find(entry_id).to_json
    end
  end
end

class DeskCreateWaitlistEntry < Pike13BaseTool
  description <<~DESC
    [STAFF] Add person to waitlist for full event.

    Creates waitlist entry for specified person.
    Person defaults to current staff member if not specified.

    Returns created entry with person, event_occurrence, state, and timestamps.

    Use to manually add people to waitlist.
  DESC

  input_schema(
    properties: {
      event_occurrence_id: { type: 'integer', description: 'Event occurrence ID to join waitlist for' },
      person_id: { type: 'integer', description: 'Optional: person ID (defaults to current staff member)' }
    },
    required: ['event_occurrence_id']
  )

  class << self
    def call(event_occurrence_id:, server_context:, person_id: nil)
      params = { event_occurrence_id: event_occurrence_id }
      params[:person_id] = person_id if person_id
      Pike13::Desk::WaitlistEntry.create(params).to_json
    end
  end
end

class DeskUpdateWaitlistEntry < Pike13BaseTool
  description <<~DESC
    [STAFF] Update waitlist entry state.

    Transitions waitlist entry between states using state_event parameter.
    Valid state_events:
    - wait: transition to "waiting" state
    - enroll: transition to "enrolled" state (does NOT add person to roster,
      only marks waitlist entry as enrolled - create a Visit to actually enroll)

    Note: Creating a Visit for a waitlisted person will automatically transition
    the waitlist entry to "enrolled" and add them to the class roster.

    Cannot transition entries in "removed" state.

    Use to manage waitlist state changes.
  DESC

  input_schema(
    properties: {
      entry_id: { type: 'integer', description: 'Waitlist entry ID to update' },
      state_event: { type: 'string', description: 'State transition (wait or enroll)' }
    },
    required: %w[entry_id state_event]
  )

  class << self
    def call(entry_id:, state_event:, server_context:)
      params = { state_event: state_event }
      Pike13::Desk::WaitlistEntry.update(entry_id, params).to_json
    end
  end
end

class DeskDeleteWaitlistEntry < Pike13BaseTool
  description <<~DESC
    [STAFF] Remove person from waitlist.

    Deletes the waitlist entry.

    Use to manually remove people from waitlist.
  DESC

  input_schema(
    properties: {
      entry_id: { type: 'integer', description: 'Waitlist entry ID to delete' }
    },
    required: ['entry_id']
  )

  class << self
    def call(entry_id:, server_context:)
      Pike13::Desk::WaitlistEntry.delete(entry_id).to_json
    end
  end
end
