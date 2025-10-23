# frozen_string_literal: true

require_relative 'base_tool'

class Pike13DeskListSalesTaxes < Pike13BaseTool
  description '[STAFF ONLY] List sales taxes'

  def call
    client.desk.sales_taxes.all.to_json
  end
end
