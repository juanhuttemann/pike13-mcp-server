# frozen_string_literal: true

require_relative '../base_tool'

class DeskListSalesTaxes < Pike13BaseTool
  description "List sales taxes"

  class << self
    def call(server_context:)
      Pike13::Desk::SalesTax.all.to_json
    end
  end
end

class DeskGetSalesTax < Pike13BaseTool
  description "Get sales tax"

  input_schema(
    properties: {
      sales_tax_id: { type: 'integer', description: 'Unique Pike13 sales tax ID' }
    },
    required: ['sales_tax_id']
  )

  class << self
    def call(sales_tax_id:, server_context:)
      Pike13::Desk::SalesTax.find(sales_tax_id).to_json
    end
  end
end
