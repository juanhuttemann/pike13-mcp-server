# frozen_string_literal: true

require_relative '../base_tool'

class DeskListRevenueCategories < Pike13BaseTool
  description "List revenue categories"

  class << self
    def call(server_context:)
      Pike13::Desk::RevenueCategory.all.to_json
    end
  end
end

class DeskGetRevenueCategory < Pike13BaseTool
  description "Get revenue category"

  input_schema(
    properties: {
      revenue_category_id: { type: 'integer', description: 'Unique Pike13 revenue category ID' }
    },
    required: ['revenue_category_id']
  )

  class << self
    def call(revenue_category_id:, server_context:)
      Pike13::Desk::RevenueCategory.find(revenue_category_id).to_json
    end
  end
end
