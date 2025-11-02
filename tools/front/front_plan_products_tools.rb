# frozen_string_literal: true

require_relative '../base_tool'

class FrontListPlanProducts < Pike13BaseTool
  description <<~DESC
    [CLIENT] List purchasable membership products visible to the user.

    Returns available membership plans for purchase with pricing, billing frequency
    (interval_unit/interval_count/days), visit limits (count/limit_period), commitment terms
    (commitment_length/commitment_unit), rollover settings, signup fees, and associated services.

    Supports filtering by location and service.

    Use to display membership options to customers for enrollment or pricing comparison.
  DESC

  input_schema(
    properties: {
      location_ids: { type: 'string', description: 'Optional: comma-delimited location IDs to filter plan products' },
      service_ids: { type: 'string', description: 'Optional: comma-delimited service IDs to filter plan products' }
    },
    required: []
  )

  class << self
    def call(server_context:, location_ids: nil, service_ids: nil)
      params = {}
      params[:location_ids] = location_ids if location_ids
      params[:service_ids] = service_ids if service_ids
      Pike13::Front::PlanProduct.all(**params).to_json
    end
  end
end

class FrontGetPlanProduct < Pike13BaseTool
  description <<~DESC
    [CLIENT] Get specific plan product details by ID.

    Returns complete plan product information including pricing, billing schedule,
    commitment terms, rollover count, signup fees, associated services, and terms & conditions.

    Use to show detailed membership information before purchase.
  DESC

  input_schema(
    properties: {
      plan_product_id: { type: 'integer', description: 'Unique Pike13 plan product ID' }
    },
    required: ['plan_product_id']
  )

  class << self
    def call(plan_product_id:, server_context:)
      Pike13::Front::PlanProduct.find(plan_product_id).to_json
    end
  end
end
