# frozen_string_literal: true

require_relative '../base_tool'

class DeskListServices < Pike13BaseTool
  description "List services"

  input_schema(
    properties: {
      include_hidden: { type: 'boolean', description: 'Include hidden services' }
    },
    required: []
  )

  class << self
    def call(server_context:, include_hidden: nil)
      params = {}
      params[:include_hidden] = include_hidden unless include_hidden.nil?
      Pike13::Desk::Service.all(**params).to_json
    end
  end
end

class DeskGetService < Pike13BaseTool
  description "Get service"

  input_schema(
    properties: {
      service_id: { type: 'integer', description: 'Service ID' }
    },
    required: ['service_id']
  )

  class << self
    def call(service_id:, server_context:)
      Pike13::Desk::Service.find(service_id).to_json
    end
  end
end

class DeskGetServiceEnrollmentEligibilities < Pike13BaseTool
  description "Check enrollment eligibility"

  input_schema(
    properties: {
      service_id: { type: 'integer', description: 'Service ID' },
      person_ids: { type: 'string', description: 'Person IDs (comma-separated)' },
      event_id: { type: 'integer', description: 'Optional: Event ID' },
      location_id: { type: 'integer', description: 'Optional: Location ID' },
      staff_member_ids: { type: 'string', description: 'Optional: Staff member IDs (comma-separated)' },
      start_at: { type: 'string', description: 'Optional: Start time (ISO 8601)' }
    },
    required: %w[service_id person_ids]
  )

  class << self
    def call(service_id:, person_ids:, server_context:, event_id: nil, location_id: nil, staff_member_ids: nil,
             start_at: nil)
      params = { person_ids: person_ids }
      params[:event_id] = event_id if event_id
      params[:location_id] = location_id if location_id
      params[:staff_member_ids] = staff_member_ids if staff_member_ids
      params[:start_at] = start_at if start_at
      Pike13::Desk::Service.enrollment_eligibilities(service_id: service_id, **params).to_json
    end
  end
end
