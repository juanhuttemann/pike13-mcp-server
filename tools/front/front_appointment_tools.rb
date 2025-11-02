# frozen_string_literal: true

require_relative "../base_tool"

class FrontFindAvailableAppointmentSlots < Pike13BaseTool
  description <<~DESC
    [CLIENT] STEP 1 for booking: Find specific appointment times.
    Returns: [{start_time, end_time, staff_member_id, service_id}].
    Use this FIRST to show available slots, then use FrontCreateVisit with chosen slot to complete booking.
    For calendar overview instead, use FrontGetAppointmentAvailabilitySummary.
  DESC

  input_schema(
    properties: {
      service_id: { type: 'integer', description: 'Service ID for the appointment type' },
      date: { type: 'string', description: 'Date to check availability in YYYY-MM-DD format (e.g., "2025-01-15")' },
      location_ids: { type: 'string', description: 'Optional: comma-separated location IDs to filter (e.g., "1,2")' },
      staff_member_ids: { type: 'string', description: 'Optional: comma-separated staff member IDs to filter (e.g., "1,2")' }
    },
    required: ['service_id', 'date']
  )

  class << self
    def call(service_id:, date:, location_ids: nil, staff_member_ids: nil, server_context:)
      params = { date: date }
      params[:location_ids] = location_ids if location_ids
      params[:staff_member_ids] = staff_member_ids if staff_member_ids

      Pike13::Front::Appointment.find_available_slots(service_id: service_id, **params).to_json
    end
  end
end

class FrontGetAppointmentAvailabilitySummary < Pike13BaseTool
  description <<~DESC
    [CLIENT] Get availability OVERVIEW only - NOT for booking specific times.
    Returns daily scores 0-1 for calendar heat maps.
    Use to find days with most availability, then use FrontFindAvailableAppointmentSlots to get actual booking times.
    Limited to 90-day range.
  DESC

  input_schema(
    properties: {
      service_id: { type: 'integer', description: 'Service ID for the appointment type' },
      from: { type: 'string', description: 'Start date in YYYY-MM-DD format (e.g., "2025-01-15")' },
      to: { type: 'string', description: 'End date in YYYY-MM-DD format (e.g., "2025-02-15"). Max 90 days from start.' },
      location_ids: { type: 'string', description: 'Optional: comma-separated location IDs to filter' },
      staff_member_ids: { type: 'string', description: 'Optional: comma-separated staff member IDs to filter' }
    },
    required: ['service_id', 'from', 'to']
  )

  class << self
    def call(service_id:, from:, to:, location_ids: nil, staff_member_ids: nil, server_context:)
      params = { from: from, to: to }
      params[:location_ids] = location_ids if location_ids
      params[:staff_member_ids] = staff_member_ids if staff_member_ids

      Pike13::Front::Appointment.available_slots_summary(service_id: service_id, **params).to_json
    end
  end
end

