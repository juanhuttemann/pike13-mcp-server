# frozen_string_literal: true

require_relative 'base_tool'

class FrontListPlanProducts < Pike13BaseTool
  description '[CLIENT] List purchasable membership products. Returns available membership plans for purchase with pricing, billing frequency, benefits, and terms. Use to display membership options to customers for enrollment or showing pricing information.'

  def call
    client.front.plan_products.all.to_json
  end
end

class DeskListPlanProducts < Pike13BaseTool
  description '[STAFF] List all membership plan products. Returns plan products with full pricing, billing settings, access rules, enrollment options, visibility, and administrative details. Use for plan configuration, sales reporting, or membership management.'

  def call
    client.desk.plan_products.all.to_json
  end
end
