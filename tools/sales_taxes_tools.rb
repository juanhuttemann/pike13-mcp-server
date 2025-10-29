# frozen_string_literal: true

require_relative 'base_tool'

class DeskListSalesTaxes < Pike13BaseTool
  description <<~DESC
    [STAFF] List available sales tax configurations.

    Returns sales taxes with id, name, and tax_rate (percentage).

    Use for understanding tax calculations, financial reporting, or pricing configuration.
  DESC

  def call
    Pike13::Desk::SalesTax.all.to_json
  end
end

class DeskGetSalesTax < Pike13BaseTool
  description <<~DESC
    [STAFF] Get sales tax details by ID.

    Returns sales tax with id, name, tax_rate, and locations (with location-specific tax rates if applicable).

    Use for viewing detailed tax configuration or location-specific rates.
  DESC

  arguments do
    required(:sales_tax_id).filled(:integer).description('Unique Pike13 sales tax ID')
  end

  def call(sales_tax_id:)
    Pike13::Desk::SalesTax.find(sales_tax_id).to_json
  end
end
