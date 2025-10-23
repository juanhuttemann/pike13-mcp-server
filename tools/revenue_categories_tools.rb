# frozen_string_literal: true

require_relative 'base_tool'

class Pike13DeskListRevenueCategories < Pike13BaseTool
  description '[STAFF ONLY] List revenue categories'

  def call
    client.desk.revenue_categories.all.to_json
  end
end
