# frozen_string_literal: true

require_relative '../base_tool'

class FrontListServices < Pike13BaseTool
  description <<~DESC
    STEP 1: List available services (yoga, personal training, etc). Returns: name, type, price, duration. Use FIRST to show what services are available, then use FrontFindAvailableAppointmentSlots to check times for appointment services, or FrontListEventOccurrences for class services.
  DESC

  class << self
    def call(server_context:)
      Pike13::Front::Service.all.to_json
    end
  end
end

class FrontGetService < Pike13BaseTool
  description <<~DESC
    Get detailed service info by ID. Returns: full description, policies, requirements. Use when customer asks "tell me about [service]" or needs details before booking. Workflow: FrontListServices → FrontGetService → FrontFindAvailableAppointmentSlots/FrontListEventOccurrences
  DESC

  input_schema(
    properties: {
      service_id: { type: 'integer', description: 'Unique Pike13 service ID' }
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
  description <<~DESC
    Check enrollment eligibility for a service for the logged-in person and dependents.

    Returns enrollment warnings and restrictions based on service configuration and person status.
    Warnings include: credit_card_required, client_purchase_disabled.
    Restrictions include: already_enrolled, full, in_the_past, inside_blackout_window,
    too_far_in_advance, plan_required, clients_not_allowed, members_not_allowed.

    Use before attempting enrollment to check eligibility and display appropriate messages.
  DESC

  input_schema(
    properties: {
      service_id: { type: 'integer', description: 'Unique Pike13 service ID' },
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
