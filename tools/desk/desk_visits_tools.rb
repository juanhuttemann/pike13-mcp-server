# frozen_string_literal: true

require_relative '../base_tool'

class DeskListVisits < Pike13BaseTool
  description <<~DESC
    [STAFF] List attendance records with optional person filter.

    Returns visits with person, event_occurrence details, state, timestamps,
    payment status, and punch usage.

    Visits are attendance records (not bookings).

    Use for attendance tracking, reporting, or viewing person history.
  DESC

  input_schema(
    properties: {
      person_id: { type: 'integer', description: 'Optional: filter visits for specific person' }
    },
    required: []
  )

  class << self
    def call(server_context:, person_id: nil)
      visits = person_id ? Pike13::Desk::Visit.all(person_id: person_id) : Pike13::Desk::Visit.all
      visits.to_json
    end
  end
end

class DeskGetVisit < Pike13BaseTool
  description <<~DESC
    [STAFF] Get complete visit (attendance) record by ID.

    Returns full visit data: person, event_occurrence, state, all timestamps,
    payment details, punch used, and status history.

    Use for attendance verification or dispute resolution.
  DESC

  input_schema(
    properties: {
      visit_id: { type: 'integer', description: 'Unique Pike13 visit ID' }
    },
    required: ['visit_id']
  )

  class << self
    def call(visit_id:, server_context:)
      Pike13::Desk::Visit.find(visit_id).to_json
    end
  end
end

class DeskCreateVisit < Pike13BaseTool
  description <<~DESC
    [STAFF] Create a visit (enroll person in event/class).

    Enrolls person in event occurrence with specified initial state.
    Can override restrictions and control client notifications.

    States: reserved (holds spot without person), registered (default, person enrolled),
    completed (marked attended), noshowed (marked no-show), late_canceled (canceled outside window).

    Restrictions can validate: inside_blackout_window, full, in_the_past.

    Use for manual enrollment, walk-ins, or administrative corrections.
  DESC

  input_schema(
    properties: {
      event_occurrence_id: { type: 'integer', description: 'Event occurrence ID to enroll in' },
      person_id: { type: 'integer', description: 'Optional: person ID (required unless state=reserved)' },
      state: { type: 'string',
               description: 'Optional: initial state (reserved/registered/completed/noshowed/late_canceled, default: registered)' },
      notify_client: { type: 'boolean', description: 'Optional: send notification to client (boolean, default true)' },
      restrictions: { type: 'array',
                      description: 'Optional: array of restrictions to validate ([inside_blackout_window, full, in_the_past])' }
    },
    required: ['event_occurrence_id']
  )

  class << self
    def call(event_occurrence_id:, server_context:, person_id: nil, state: nil, notify_client: nil, restrictions: nil)
      params = { event_occurrence_id: event_occurrence_id }
      params[:person_id] = person_id if person_id
      params[:state] = state if state
      params[:notify_client] = notify_client unless notify_client.nil?
      params[:restrictions] = restrictions if restrictions
      Pike13::Desk::Visit.create(params).to_json
    end
  end
end

class DeskUpdateVisit < Pike13BaseTool
  description <<~DESC
    [STAFF] Update visit state (mark attendance/no-show/late cancel).

    Transitions visit between states using state_event parameter.
    Valid state_events:
    - register: reserved -> registered (requires person_id)
    - complete: registered -> completed
    - noshow: registered -> noshowed
    - late_cancel: registered -> late_canceled
    - reset: (completed/noshowed/late_canceled) -> registered

    Person_id can be set but not changed once set.

    Use for marking attendance, handling no-shows, or administrative corrections.
  DESC

  input_schema(
    properties: {
      visit_id: { type: 'integer', description: 'Visit ID to update' },
      state_event: { type: 'string',
                     description: 'Optional: state transition (register/complete/noshow/late_cancel/reset)' },
      person_id: { type: 'integer', description: 'Optional: person ID (only when registering reserved visit)' }
    },
    required: ['visit_id']
  )

  class << self
    def call(visit_id:, server_context:, state_event: nil, person_id: nil)
      params = {}
      params[:state_event] = state_event if state_event
      params[:person_id] = person_id if person_id
      Pike13::Desk::Visit.update(visit_id, params).to_json
    end
  end
end

class DeskDeleteVisit < Pike13BaseTool
  description <<~DESC
    [STAFF] Delete visit and optionally future recurring visits.

    Removes visit from roster. Can control client notifications and remove all future
    recurring enrollments in the same event series.

    Use for cancellations, schedule changes, or administrative corrections.
  DESC

  input_schema(
    properties: {
      visit_id: { type: 'integer', description: 'Visit ID to delete' },
      notify_client: { type: 'boolean', description: 'Optional: send notification to client (boolean, default true)' },
      remove_recurring_enrollment: { type: 'boolean',
                                     description: 'Optional: remove future recurring visits (boolean, default false)' }
    },
    required: ['visit_id']
  )

  class << self
    def call(visit_id:, server_context:, notify_client: nil, remove_recurring_enrollment: nil)
      params = {}
      params[:notify_client] = notify_client unless notify_client.nil?
      params[:remove_recurring_enrollment] = remove_recurring_enrollment if remove_recurring_enrollment
      Pike13::Desk::Visit.destroy(visit_id, **params).to_json
    end
  end
end
