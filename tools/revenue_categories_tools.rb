# frozen_string_literal: true

require_relative 'base_tool'

class DeskListRevenueCategories < Pike13BaseTool
  description <<~DESC
    [STAFF] List revenue classification categories.

    Returns accounting categories for income tracking with id and name.
    Revenue categories are never deleted but names can be edited and may change over time.

    Use for financial reporting, revenue analysis, or understanding how income is categorized.
  DESC

  def call
    Pike13::Desk::RevenueCategory.all.to_json
  end
end

class DeskGetRevenueCategory < Pike13BaseTool
  description <<~DESC
    [STAFF] Get revenue category details by ID.

    Returns revenue category with id and name.

    Use for viewing specific category details or validation.
  DESC

  arguments do
    required(:revenue_category_id).filled(:integer).description('Unique Pike13 revenue category ID')
  end

  def call(revenue_category_id:)
    Pike13::Desk::RevenueCategory.find(revenue_category_id).to_json
  end
end
