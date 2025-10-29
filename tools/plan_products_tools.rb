# frozen_string_literal: true

require_relative 'base_tool'

class FrontListPlanProducts < Pike13BaseTool
  description <<~DESC
    [CLIENT] List purchasable membership products visible to the user.

    Returns available membership plans for purchase with pricing, billing frequency
    (interval_unit/interval_count/days), visit limits (count/limit_period), commitment terms
    (commitment_length/commitment_unit), rollover settings, signup fees, and associated services.

    Supports filtering by location and service.

    Use to display membership options to customers for enrollment or pricing comparison.
  DESC

  arguments do
    optional(:location_ids).maybe(:string).description('Optional: comma-delimited location IDs to filter plan products')
    optional(:service_ids).maybe(:string).description('Optional: comma-delimited service IDs to filter plan products')
  end

  def call(location_ids: nil, service_ids: nil)
    params = {}
    params[:location_ids] = location_ids if location_ids
    params[:service_ids] = service_ids if service_ids
    Pike13::Front::PlanProduct.all(params).to_json
  end
end

class FrontGetPlanProduct < Pike13BaseTool
  description <<~DESC
    [CLIENT] Get specific plan product details by ID.

    Returns complete plan product information including pricing, billing schedule,
    commitment terms, rollover count, signup fees, associated services, and terms & conditions.

    Use to show detailed membership information before purchase.
  DESC

  arguments do
    required(:plan_product_id).filled(:integer).description('Unique Pike13 plan product ID')
  end

  def call(plan_product_id:)
    Pike13::Front::PlanProduct.find(plan_product_id).to_json
  end
end

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

  arguments do
    optional(:location_ids).maybe(:string).description('Optional: comma-delimited location IDs to filter plan products')
    optional(:service_ids).maybe(:string).description('Optional: comma-delimited service IDs to filter plan products')
  end

  def call(location_ids: nil, service_ids: nil)
    params = {}
    params[:location_ids] = location_ids if location_ids
    params[:service_ids] = service_ids if service_ids
    Pike13::Desk::PlanProduct.all(params).to_json
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

  arguments do
    required(:plan_product_id).filled(:integer).description('Unique Pike13 plan product ID')
  end

  def call(plan_product_id:)
    Pike13::Desk::PlanProduct.find(plan_product_id).to_json
  end
end
