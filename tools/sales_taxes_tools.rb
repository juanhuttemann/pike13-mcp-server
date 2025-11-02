# frozen_string_literal: true

require_relative 'base_tool'

class DeskListSalesTaxes < Pike13BaseTool
  description <<~DESC
    List available sales tax configurations.

    Returns sales taxes with id, name, and tax_rate (percentage).

    Use for understanding tax calculations, financial reporting, or pricing configuration.
  DESC

  class << self
    def call(server_context:)
      Pike13::Desk::SalesTax.all.to_json
    end
  end
end

class DeskGetSalesTax < Pike13BaseTool
  description <<~DESC
    Get sales tax details by ID.

    Returns sales tax with id, name, tax_rate, and locations (with location-specific tax rates if applicable).

    Use for viewing detailed tax configuration or location-specific rates.
  DESC

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
