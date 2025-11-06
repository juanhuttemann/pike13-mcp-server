# frozen_string_literal: true

require_relative '../base_tool'

class FrontFindAvailableAppointmentSlots < Pike13BaseTool
  description "Find available appointment slots"

  input_schema(
    properties: {
      service_id: { type: 'integer', description: 'Service ID for the appointment type' },
      date: { type: 'string', description: 'Date to check availability (YYYY-MM-DD)' },
      location_ids: { type: 'string', description: 'Optional: Location IDs (comma-separated)' },
      staff_member_ids: { type: 'string',
                          description: 'Optional: Staff member IDs (comma-separated)' }
    },
    required: %w[service_id date]
  )

  class << self
    def call(service_id:, date:, server_context:, location_ids: nil, staff_member_ids: nil)
      params = { date: date }
      params[:location_ids] = location_ids if location_ids
      params[:staff_member_ids] = staff_member_ids if staff_member_ids

      Pike13::Front::Appointment.find_available_slots(service_id: service_id, **params).to_json
    end
  end
end

class FrontGetAppointmentAvailabilitySummary < Pike13BaseTool
  description "Get appointment availability summary"

  input_schema(
    properties: {
      service_id: { type: 'integer', description: 'Service ID for the appointment type' },
      from: { type: 'string', description: 'Start date (YYYY-MM-DD)' },
      to: { type: 'string', description: 'End date (YYYY-MM-DD, max 90 days)' },
      location_ids: { type: 'string', description: 'Optional: Location IDs (comma-separated)' },
      staff_member_ids: { type: 'string', description: 'Optional: Staff member IDs (comma-separated)' }
    },
    required: %w[service_id from to]
  )

  class << self
    def call(service_id:, from:, to:, server_context:, location_ids: nil, staff_member_ids: nil)
      params = { from: from, to: to }
      params[:location_ids] = location_ids if location_ids
      params[:staff_member_ids] = staff_member_ids if staff_member_ids

      Pike13::Front::Appointment.available_slots_summary(service_id: service_id, **params).to_json
    end
  end
end
