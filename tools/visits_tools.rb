# frozen_string_literal: true

require_relative 'base_tool'

class FrontListVisits < Pike13BaseTool
  description <<~DESC
    [CLIENT] List authenticated customer attendance records.

    Returns visits (attendance at events or appointments) with person, event_occurrence details,
    state (reserved/registered/completed/noshowed/late_canceled), timestamps (registered_at/completed_at/
    noshow_at/cancelled_at), payment status (paid/paid_for_by), and punch_id if applicable.

    Use to show customer their attendance history.
  DESC

  def call
    Pike13::Front::Visit.all.to_json
  end
end

class FrontGetVisit < Pike13BaseTool
  description <<~DESC
    [CLIENT] Get customer visit (attendance record) by ID.

    Returns visit details: person, event_occurrence (name/start_at/end_at/service/location),
    state, timestamps, payment status, and associated punch.

    Use to show specific attendance details to customer.
  DESC

  arguments do
    required(:visit_id).filled(:integer).description('Unique Pike13 visit ID')
  end

  def call(visit_id:)
    Pike13::Front::Visit.find(visit_id).to_json
  end
end

class FrontCreateVisit < Pike13BaseTool
  description <<~DESC
    [CLIENT] STEP 2 for booking: Complete appointment/class booking.

    Creates visit (attendance record) after finding available slots with FrontFindAvailableAppointmentSlots. Use event_occurrence_id from availability check or event listing.

    Returns: visit_id, status, event details. Next: Use FrontGetVisit to check booking details.

    Workflow: FrontFindAvailableAppointmentSlots → FrontCreateVisit → FrontGetVisit
  DESC

  arguments do
    required(:event_occurrence_id).filled(:integer).description('Event occurrence ID to enroll in')
    optional(:person_id).maybe(:integer).description('Optional: person ID (defaults to authenticated person)')
  end

  def call(event_occurrence_id:, person_id: nil)
    params = { event_occurrence_id: event_occurrence_id }
    params[:person_id] = person_id if person_id
    Pike13::Front::Visit.create(params).to_json
  end
end

class FrontDeleteVisit < Pike13BaseTool
  description <<~DESC
    [CLIENT] Cancel a visit if free to cancel.

    Removes visit from roster. Can optionally remove all future recurring visits.
    Only works if visit is within free cancellation window.

    Use to allow customers to cancel their enrollment.
  DESC

  arguments do
    required(:visit_id).filled(:integer).description('Visit ID to cancel')
    optional(:remove_recurring_enrollment).maybe(:bool).description('Optional: remove future recurring visits (boolean, default false)')
  end

  def call(visit_id:, remove_recurring_enrollment: nil)
    params = {}
    params[:remove_recurring_enrollment] = remove_recurring_enrollment if remove_recurring_enrollment
    Pike13::Front::Visit.destroy(visit_id, **params).to_json
  end
end

class DeskListVisits < Pike13BaseTool
  description <<~DESC
    [STAFF] List attendance records with optional person filter.

    Returns visits with person, event_occurrence details, state, timestamps,
    payment status, and punch usage.

    Visits are attendance records (not bookings).

    Use for attendance tracking, reporting, or viewing person history.
  DESC

  arguments do
    optional(:person_id).maybe(:integer).description('Optional: filter visits for specific person')
  end

  def call(person_id: nil)
    visits = person_id ? Pike13::Desk::Visit.all(person_id: person_id) : Pike13::Desk::Visit.all
    visits.to_json
  end
end

class DeskGetVisit < Pike13BaseTool
  description <<~DESC
    [STAFF] Get complete visit (attendance) record by ID.

    Returns full visit data: person, event_occurrence, state, all timestamps,
    payment details, punch used, and status history.

    Use for attendance verification or dispute resolution.
  DESC

  arguments do
    required(:visit_id).filled(:integer).description('Unique Pike13 visit ID')
  end

  def call(visit_id:)
    Pike13::Desk::Visit.find(visit_id).to_json
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

  arguments do
    required(:event_occurrence_id).filled(:integer).description('Event occurrence ID to enroll in')
    optional(:person_id).maybe(:integer).description('Optional: person ID (required unless state=reserved)')
    optional(:state).maybe(:string).description('Optional: initial state (reserved/registered/completed/noshowed/late_canceled, default: registered)')
    optional(:notify_client).maybe(:bool).description('Optional: send notification to client (boolean, default true)')
    optional(:restrictions).maybe(:array).description('Optional: array of restrictions to validate ([inside_blackout_window, full, in_the_past])')
  end

  def call(event_occurrence_id:, person_id: nil, state: nil, notify_client: nil, restrictions: nil)
    params = { event_occurrence_id: event_occurrence_id }
    params[:person_id] = person_id if person_id
    params[:state] = state if state
    params[:notify_client] = notify_client unless notify_client.nil?
    params[:restrictions] = restrictions if restrictions
    Pike13::Desk::Visit.create(params).to_json
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

  arguments do
    required(:visit_id).filled(:integer).description('Visit ID to update')
    optional(:state_event).maybe(:string).description('Optional: state transition (register/complete/noshow/late_cancel/reset)')
    optional(:person_id).maybe(:integer).description('Optional: person ID (only when registering reserved visit)')
  end

  def call(visit_id:, state_event: nil, person_id: nil)
    params = {}
    params[:state_event] = state_event if state_event
    params[:person_id] = person_id if person_id
    Pike13::Desk::Visit.update(visit_id, params).to_json
  end
end

class DeskDeleteVisit < Pike13BaseTool
  description <<~DESC
    [STAFF] Delete visit and optionally future recurring visits.

    Removes visit from roster. Can control client notifications and remove all future
    recurring enrollments in the same event series.

    Use for cancellations, schedule changes, or administrative corrections.
  DESC

  arguments do
    required(:visit_id).filled(:integer).description('Visit ID to delete')
    optional(:notify_client).maybe(:bool).description('Optional: send notification to client (boolean, default true)')
    optional(:remove_recurring_enrollment).maybe(:bool).description('Optional: remove future recurring visits (boolean, default false)')
  end

  def call(visit_id:, notify_client: nil, remove_recurring_enrollment: nil)
    params = {}
    params[:notify_client] = notify_client unless notify_client.nil?
    params[:remove_recurring_enrollment] = remove_recurring_enrollment if remove_recurring_enrollment
    Pike13::Desk::Visit.destroy(visit_id, **params).to_json
  end
end
