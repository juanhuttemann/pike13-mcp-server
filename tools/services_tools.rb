# frozen_string_literal: true

require_relative 'base_tool'

class FrontListServices < Pike13BaseTool
  description <<~DESC
    [CLIENT] STEP 1: List available services (yoga, personal training, etc). Returns: name, type, price, duration. Use FIRST to show what services are available, then use FrontFindAvailableAppointmentSlots to check times for appointment services, or FrontListEventOccurrences for class services.
  DESC

  def call
    Pike13::Front::Service.all.to_json
  end
end

class FrontGetService < Pike13BaseTool
  description <<~DESC
    [CLIENT] Get detailed service info by ID. Returns: full description, policies, requirements. Use when customer asks "tell me about [service]" or needs details before booking. Workflow: FrontListServices → FrontGetService → FrontFindAvailableAppointmentSlots/FrontListEventOccurrences
  DESC

  arguments do
    required(:service_id).filled(:integer).description('Unique Pike13 service ID')
  end

  def call(service_id:)
    Pike13::Front::Service.find(service_id).to_json
  end
end

class FrontGetServiceEnrollmentEligibilities < Pike13BaseTool
  description <<~DESC
    [CLIENT] Check enrollment eligibility for a service for the logged-in person and dependents.

    Returns enrollment warnings and restrictions based on service configuration and person status.
    Warnings include: credit_card_required, client_purchase_disabled.
    Restrictions include: already_enrolled, full, in_the_past, inside_blackout_window,
    too_far_in_advance, plan_required, clients_not_allowed, members_not_allowed.

    Use before attempting enrollment to check eligibility and display appropriate messages.
  DESC

  arguments do
    required(:service_id).filled(:integer).description('Unique Pike13 service ID')
    optional(:event_id).maybe(:integer).description('Optional: event ID for course enrollment checks')
    optional(:location_id).maybe(:integer).description('Optional: location ID to differentiate services')
    optional(:staff_member_ids).maybe(:string).description('Optional: comma-delimited staff member IDs')
    optional(:start_at).maybe(:string).description('Optional: ISO 8601 timestamp when service starts')
  end

  def call(service_id:, event_id: nil, location_id: nil, staff_member_ids: nil, start_at: nil)
    params = {}
    params[:event_id] = event_id if event_id
    params[:location_id] = location_id if location_id
    params[:staff_member_ids] = staff_member_ids if staff_member_ids
    params[:start_at] = start_at if start_at
    Pike13::Front::Service.find(service_id).enrollment_eligibilities(params).to_json
  end
end

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

  arguments do
    optional(:include_hidden).maybe(:bool).description('Optional: include hidden services (boolean)')
  end

  def call(include_hidden: nil)
    params = {}
    params[:include_hidden] = include_hidden unless include_hidden.nil?
    if params.empty?
      Pike13::Desk::Service.all.to_json
    else
      Pike13::Desk::Service.all(params).to_json
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

  arguments do
    required(:service_id).filled(:integer).description('Unique Pike13 service ID')
  end

  def call(service_id:)
    Pike13::Desk::Service.find(service_id).to_json
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

  arguments do
    required(:service_id).filled(:integer).description('Unique Pike13 service ID')
    required(:person_ids).filled(:string).description('Required: comma-delimited person IDs')
    optional(:event_id).maybe(:integer).description('Optional: event ID for course enrollment checks')
    optional(:location_id).maybe(:integer).description('Optional: location ID to differentiate services')
    optional(:staff_member_ids).maybe(:string).description('Optional: comma-delimited staff member IDs')
    optional(:start_at).maybe(:string).description('Optional: ISO 8601 timestamp when service starts')
  end

  def call(service_id:, person_ids:, event_id: nil, location_id: nil, staff_member_ids: nil, start_at: nil)
    params = { person_ids: person_ids }
    params[:event_id] = event_id if event_id
    params[:location_id] = location_id if location_id
    params[:staff_member_ids] = staff_member_ids if staff_member_ids
    params[:start_at] = start_at if start_at
    Pike13::Desk::Service.find(service_id).enrollment_eligibilities(params).to_json
  end
end
