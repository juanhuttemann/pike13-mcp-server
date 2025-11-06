# frozen_string_literal: true

require_relative '../base_tool'

class DeskListPlanProducts < Pike13BaseTool
  description "List plan products"

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
      Pike13::Desk::PlanProduct.all(**params).to_json
    end
  end
end

class DeskGetPlanProduct < Pike13BaseTool
  description "Get plan product"

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
