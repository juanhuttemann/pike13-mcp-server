# frozen_string_literal: true

require_relative "../base_tool"

class DeskListServices < Pike13BaseTool
  description <<~DESC
    [STAFF] List all services with administrative details.

    Returns complete service catalog with type (GroupClass/Appointment/Course), descriptions,
    duration settings (duration_in_minutes/snap_duration/setup_duration/cleanup_duration),
    enrollment windows, visibility (visitors/clients/members can view/book), capacity settings,
    anonymous_staff flag, allow_tips, require_cc, require_plan, pricing with taxes and plan products,
    cancellation policies, calendar color, category, and hidden_at timestamp.

    Supports filtering to include hidden services.

    Use for service configuration, schedule planning, or administrative management.
  DESC

  input_schema(
    properties: {
      include_hidden: { type: 'boolean', description: 'Optional: include hidden services (boolean)' }
    },
    required: []
  )

  class << self
    def call(include_hidden: nil, server_context:)
      params = {}
      params[:include_hidden] = include_hidden unless include_hidden.nil?
      Pike13::Desk::Service.all(**params).to_json
    end
  end
end

class DeskGetService < Pike13BaseTool
  description <<~DESC
    [STAFF] Get complete service details by ID.

    Returns full administrative data: type, descriptions, all duration settings, enrollment windows,
    visibility permissions for all user types, capacity and display settings, tip configuration,
    payment requirements, pricing structure, cancellation policies, category, and calendar color.

    Use for detailed service review, configuration verification, or customer service inquiries.
  DESC

  input_schema(
    properties: {
      service_id: { type: 'integer', description: 'Unique Pike13 service ID' }
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
  description <<~DESC
    [STAFF] Check enrollment eligibility for a service for specified persons.

    Returns enrollment warnings and restrictions for each person ID provided.
    Does not return dependents. Requires person_ids parameter.

    Warnings include: credit_card_required, client_purchase_disabled.
    Restrictions include: already_enrolled, full, in_the_past, inside_blackout_window,
    too_far_in_advance, plan_required, clients_not_allowed, members_not_allowed.

    Use before enrolling persons to validate eligibility.
  DESC

  input_schema(
    properties: {
      service_id: { type: 'integer', description: 'Unique Pike13 service ID' },
      person_ids: { type: 'string', description: 'Required: comma-delimited person IDs' },
      event_id: { type: 'integer', description: 'Optional: event ID for course enrollment checks' },
      location_id: { type: 'integer', description: 'Optional: location ID to differentiate services' },
      staff_member_ids: { type: 'string', description: 'Optional: comma-delimited staff member IDs' },
      start_at: { type: 'string', description: 'Optional: ISO 8601 timestamp when service starts' }
    },
    required: ['service_id', 'person_ids']
  )

  class << self
    def call(service_id:, person_ids:, event_id: nil, location_id: nil, staff_member_ids: nil, start_at: nil, server_context:)
      params = { person_ids: person_ids }
      params[:event_id] = event_id if event_id
      params[:location_id] = location_id if location_id
      params[:staff_member_ids] = staff_member_ids if staff_member_ids
      params[:start_at] = start_at if start_at
      Pike13::Desk::Service.enrollment_eligibilities(service_id: service_id, **params).to_json
    end
  end
end
