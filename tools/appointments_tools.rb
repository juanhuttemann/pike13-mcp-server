# frozen_string_literal: true

require_relative 'base_tool'

class FrontFindAvailableAppointmentSlots < Pike13BaseTool
  description <<~DESC
    [CLIENT] STEP 1 for booking: Find specific appointment times.
    Returns: [{start_time, end_time, staff_member_id, service_id}].
    Use this FIRST to show available slots, then use FrontCreateVisit with chosen slot to complete booking.
    For calendar overview instead, use FrontGetAppointmentAvailabilitySummary.
  DESC

  arguments do
    required(:service_id).filled(:integer).description('Service ID for the appointment type')
    required(:date).filled(:string).description('Date to check availability in YYYY-MM-DD format (e.g., "2025-01-15")')
    optional(:location_ids).maybe(:string).description('Optional: comma-separated location IDs to filter (e.g., "1,2")')
    optional(:staff_member_ids).maybe(:string).description('Optional: comma-separated staff member IDs to filter (e.g., "1,2")')
  end

  def call(service_id:, date:, location_ids: nil, staff_member_ids: nil)
    params = { date: date }
    params[:location_ids] = location_ids if location_ids
    params[:staff_member_ids] = staff_member_ids if staff_member_ids

    Pike13::Front::Appointment.find_available_slots(service_id: service_id, **params).to_json
  end
end

class FrontGetAppointmentAvailabilitySummary < Pike13BaseTool
  description <<~DESC
    [CLIENT] Get availability OVERVIEW only - NOT for booking specific times.
    Returns daily scores 0-1 for calendar heat maps.
    Use to find days with most availability, then use FrontFindAvailableAppointmentSlots to get actual booking times.
    Limited to 90-day range.
  DESC

  arguments do
    required(:service_id).filled(:integer).description('Service ID for the appointment type')
    required(:from).filled(:string).description('Start date in YYYY-MM-DD format (e.g., "2025-01-15")')
    required(:to).filled(:string).description('End date in YYYY-MM-DD format (e.g., "2025-02-15"). Max 90 days from start.')
    optional(:location_ids).maybe(:string).description('Optional: comma-separated location IDs to filter')
    optional(:staff_member_ids).maybe(:string).description('Optional: comma-separated staff member IDs to filter')
  end

  def call(service_id:, from:, to:, location_ids: nil, staff_member_ids: nil)
    params = { from: from, to: to }
    params[:location_ids] = location_ids if location_ids
    params[:staff_member_ids] = staff_member_ids if staff_member_ids

    Pike13::Front::Appointment.available_slots_summary(service_id: service_id, **params).to_json
  end
end

class DeskFindAvailableAppointmentSlots < Pike13BaseTool
  description <<~DESC
    [STAFF] Find available appointment time slots for a service.
    Returns array of available times with start times, duration, staff member, and pricing.
    Use for staff to check appointment availability when booking for clients.
  DESC

  arguments do
    required(:service_id).filled(:integer).description('Service ID for the appointment type')
    required(:date).filled(:string).description('Date to check availability in YYYY-MM-DD format (e.g., "2025-01-15")')
    optional(:location_ids).maybe(:string).description('Optional: comma-separated location IDs to filter (e.g., "1,2")')
    optional(:staff_member_ids).maybe(:string).description('Optional: comma-separated staff member IDs to filter (e.g., "1,2")')
  end

  def call(service_id:, date:, location_ids: nil, staff_member_ids: nil)
    params = { date: date }
    params[:location_ids] = location_ids if location_ids
    params[:staff_member_ids] = staff_member_ids if staff_member_ids

    Pike13::Desk::Appointment.find_available_slots(service_id: service_id, **params).to_json
  end
end

class DeskGetAppointmentAvailabilitySummary < Pike13BaseTool
  description <<~DESC
    [STAFF] Get appointment availability heat map for date range.
    Returns availability scores (0-1) for each day showing relative availability with admin details.
    Use for staff scheduling analysis or capacity planning.
    Limited to 90-day range.
  DESC

  arguments do
    required(:service_id).filled(:integer).description('Service ID for the appointment type')
    required(:from).filled(:string).description('Start date in YYYY-MM-DD format (e.g., "2025-01-15")')
    required(:to).filled(:string).description('End date in YYYY-MM-DD format (e.g., "2025-02-15"). Max 90 days from start.')
    optional(:location_ids).maybe(:string).description('Optional: comma-separated location IDs to filter')
    optional(:staff_member_ids).maybe(:string).description('Optional: comma-separated staff member IDs to filter')
  end

  def call(service_id:, from:, to:, location_ids: nil, staff_member_ids: nil)
    params = { from: from, to: to }
    params[:location_ids] = location_ids if location_ids
    params[:staff_member_ids] = staff_member_ids if staff_member_ids

    Pike13::Desk::Appointment.available_slots_summary(service_id: service_id, **params).to_json
  end
end
