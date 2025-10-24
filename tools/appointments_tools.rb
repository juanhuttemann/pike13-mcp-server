# frozen_string_literal: true

require_relative 'base_tool'

class Pike13FrontFindAvailableAppointmentSlots < Pike13BaseTool
  description '[CLIENT] Find available appointment time slots for a service. Returns array of available times with start times, duration, and staff member. Use to show customers when they can book appointments for a specific service.'

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

    client.front.appointments.find_available_slots(service_id: service_id, **params).to_json
  end
end

class Pike13FrontGetAppointmentAvailabilitySummary < Pike13BaseTool
  description '[CLIENT] Get appointment availability heat map for date range. Returns availability scores (0-1) for each day showing relative availability. Use to display calendar heat map or find days with most availability. Limited to 90-day range.'

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

    client.front.appointments.available_slots_summary(service_id: service_id, **params).to_json
  end
end

class Pike13DeskFindAvailableAppointmentSlots < Pike13BaseTool
  description '[STAFF] Find available appointment time slots for a service. Returns array of available times with start times, duration, staff member, and pricing. Use for staff to check appointment availability when booking for clients.'

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

    client.desk.appointments.find_available_slots(service_id: service_id, **params).to_json
  end
end

class Pike13DeskGetAppointmentAvailabilitySummary < Pike13BaseTool
  description '[STAFF] Get appointment availability heat map for date range. Returns availability scores (0-1) for each day showing relative availability with admin details. Use for staff scheduling analysis or capacity planning. Limited to 90-day range.'

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

    client.desk.appointments.available_slots_summary(service_id: service_id, **params).to_json
  end
end
