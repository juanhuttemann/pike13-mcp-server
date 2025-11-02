# frozen_string_literal: true

require_relative "../base_tool"

class DeskListPlanProducts < Pike13BaseTool
  description <<~DESC
    [STAFF] List all membership plan products for the business.

    Returns plan products with complete administrative details: pricing, billing settings
    (interval_unit/interval_count/days/days_of_month/months_of_year), visit limits,
    commitment terms, hold policies, signup/cancellation fees, tax exemption settings,
    rollover counts, member benefits, notification settings, terms acceptance requirements,
    and associated services.

    Supports filtering by location and service.

    Use for plan configuration, sales reporting, membership management, or administrative tasks.
  DESC

  input_schema(
    properties: {
      location_ids: { type: 'string', description: 'Optional: comma-delimited location IDs to filter plan products' },
      service_ids: { type: 'string', description: 'Optional: comma-delimited service IDs to filter plan products' }
    },
    required: []
  )

  class << self
    def call(location_ids: nil, service_ids: nil, server_context:)
      params = {}
      params[:location_ids] = location_ids if location_ids
      params[:service_ids] = service_ids if service_ids
      Pike13::Desk::PlanProduct.all(**params).to_json
    end
  end
end

class DeskGetPlanProduct < Pike13BaseTool
  description <<~DESC
    [STAFF] Get complete plan product details by ID.

    Returns full administrative data: pricing, billing configuration, commitment settings,
    hold policies (holds_allowed/hold_limit_unit/hold_limit_length/hold_fee_cents),
    signup/cancellation fees with tax exemption flags, rollover settings, member consideration flags,
    expiration notifications, terms acceptance settings, visibility, suspension status,
    timestamps, and all associated services.

    Use for detailed plan review, configuration verification, or customer service inquiries.
  DESC

  input_schema(
    properties: {
      plan_product_id: { type: 'integer', description: 'Unique Pike13 plan product ID' }
    },
    required: ['plan_product_id']
  )

  class << self
    def call(plan_product_id:, server_context:)
      Pike13::Desk::PlanProduct.find(plan_product_id).to_json
    end
  end
end
