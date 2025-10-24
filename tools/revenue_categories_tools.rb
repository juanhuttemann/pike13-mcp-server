# frozen_string_literal: true

require_relative 'base_tool'

class DeskListRevenueCategories < Pike13BaseTool
  description '[STAFF ONLY] List revenue classification categories. Returns accounting categories for income tracking (e.g., memberships, retail, drop-ins) with names, codes, and tax settings. Use for financial reporting, revenue analysis, or understanding how income is categorized for accounting purposes.'

  def call
    client.desk.revenue_categories.all.to_json
  end
end
