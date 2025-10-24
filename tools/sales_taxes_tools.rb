# frozen_string_literal: true

require_relative 'base_tool'

class DeskListSalesTaxes < Pike13BaseTool
  description '[STAFF ONLY] List configured sales tax rates. Returns tax configurations with name, rate, jurisdiction, and applicability rules. Use for understanding tax calculations, financial reporting, or configuring pricing. Shows tax rates applied to invoices and sales.'

  def call
    client.desk.sales_taxes.all.to_json
  end
end
