# frozen_string_literal: true

require_relative 'base_tool'

class Pike13FrontListPlans < Pike13BaseTool
  description '[CLIENT] List active membership plans for customer. Returns user memberships with plan name, type, billing frequency, expiration, and benefits. Use to show customer their current membership status and what access they have.'

  def call
    client.front.plans.all.to_json
  end
end

class Pike13DeskListPlans < Pike13BaseTool
  description '[STAFF] List all membership plans. Returns plans with pricing, billing terms, access rules, visit allowances, expiration policies, and enrollment status. Use for plan management, reporting, or understanding membership structures.'

  def call
    client.desk.plans.all.to_json
  end
end
