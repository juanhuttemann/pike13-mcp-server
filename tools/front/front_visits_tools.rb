# frozen_string_literal: true

require_relative '../base_tool'

class FrontListVisits < Pike13BaseTool
  description <<~DESC
    [CLIENT] List authenticated customer attendance records.

    Returns visits (attendance at events or appointments) with person, event_occurrence details,
    state (reserved/registered/completed/noshowed/late_canceled), timestamps (registered_at/completed_at/
    noshow_at/cancelled_at), payment status (paid/paid_for_by), and punch_id if applicable.

    Use to show customer their attendance history.
  DESC

  class << self
    def call(server_context:)
      Pike13::Front::Visit.all.to_json
    end
  end
end

class FrontGetVisit < Pike13BaseTool
  description <<~DESC
    [CLIENT] Get customer visit (attendance record) by ID.

    Returns visit details: person, event_occurrence (name/start_at/end_at/service/location),
    state, timestamps, payment status, and associated punch.

    Use to show specific attendance details to customer.
  DESC

  input_schema(
    properties: {
      visit_id: { type: 'integer', description: 'Unique Pike13 visit ID' }
    },
    required: ['visit_id']
  )

  class << self
    def call(visit_id:, server_context:)
      Pike13::Front::Visit.find(visit_id).to_json
    end
  end
end

class FrontCreateVisit < Pike13BaseTool
  description <<~DESC
    [CLIENT] STEP 2 for booking: Complete appointment/class booking.

    Creates visit (attendance record) after finding available slots with FrontFindAvailableAppointmentSlots. Use event_occurrence_id from availability check or event listing.

    Returns: visit_id, status, event details. Next: Use FrontGetVisit to check booking details.

    Workflow: FrontFindAvailableAppointmentSlots → FrontCreateVisit → FrontGetVisit
  DESC

  input_schema(
    properties: {
      event_occurrence_id: { type: 'integer', description: 'Event occurrence ID to enroll in' },
      person_id: { type: 'integer', description: 'Optional: person ID (defaults to authenticated person)' }
    },
    required: ['event_occurrence_id']
  )

  class << self
    def call(event_occurrence_id:, server_context:, person_id: nil)
      params = { event_occurrence_id: event_occurrence_id }
      params[:person_id] = person_id if person_id
      Pike13::Front::Visit.create(params).to_json
    end
  end
end

class FrontDeleteVisit < Pike13BaseTool
  description <<~DESC
    [CLIENT] Cancel a visit if free to cancel.

    Removes visit from roster. Can optionally remove all future recurring visits.
    Only works if visit is within free cancellation window.

    Use to allow customers to cancel their enrollment.
  DESC

  input_schema(
    properties: {
      visit_id: { type: 'integer', description: 'Visit ID to cancel' },
      remove_recurring_enrollment: { type: 'boolean',
                                     description: 'Optional: remove future recurring visits (boolean, default false)' }
    },
    required: ['visit_id']
  )

  class << self
    def call(visit_id:, server_context:, remove_recurring_enrollment: nil)
      params = {}
      params[:remove_recurring_enrollment] = remove_recurring_enrollment if remove_recurring_enrollment
      Pike13::Front::Visit.destroy(visit_id, **params).to_json
    end
  end
end
