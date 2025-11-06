# frozen_string_literal: true

require_relative '../base_tool'

class FrontListServices < Pike13BaseTool
  description "List available services"

  class << self
    def call(server_context:)
      Pike13::Front::Service.all.to_json
    end
  end
end

class FrontGetService < Pike13BaseTool
  description "Get service details"

  input_schema(
    properties: {
      service_id: { type: 'integer', description: 'Service ID' }
    },
    required: ['service_id']
  )

  class << self
    def call(service_id:, server_context:)
      Pike13::Front::Service.find(service_id).to_json
    end
  end
end

class FrontGetServiceEnrollmentEligibilities < Pike13BaseTool
  description "Check service enrollment eligibility"

  input_schema(
    properties: {
      service_id: { type: 'integer', description: 'Service ID' },
      event_id: { type: 'integer', description: 'Optional: event ID for course enrollment checks' },
      location_id: { type: 'integer', description: 'Optional: location ID to differentiate services' },
      staff_member_ids: { type: 'string', description: 'Optional: comma-delimited staff member IDs' },
      start_at: { type: 'string', description: 'Optional: ISO 8601 timestamp when service starts' }
    },
    required: ['service_id']
  )

  class << self
    def call(service_id:, server_context:, event_id: nil, location_id: nil, staff_member_ids: nil, start_at: nil)
      params = {}
      params[:event_id] = event_id if event_id
      params[:location_id] = location_id if location_id
      params[:staff_member_ids] = staff_member_ids if staff_member_ids
      params[:start_at] = start_at if start_at
      Pike13::Front::Service.enrollment_eligibilities(service_id: service_id, **params).to_json
    end
  end
end
