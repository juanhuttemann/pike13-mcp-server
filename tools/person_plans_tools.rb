# frozen_string_literal: true

require_relative 'base_tool'

class DeskListPersonPlans < Pike13BaseTool
  description <<~DESC
    [STAFF] List all membership plans for a person.
    Returns array of plan objects with plan details, status (active/cancelled/expired), start/end dates, billing info, remaining credits, and auto-renewal settings.
    Use for membership management, billing inquiries, or plan verification.
  DESC

  arguments do
    required(:person_id).filled(:integer).description('Unique Pike13 person ID (integer)')
  end

  def call(person_id:)
    Pike13::Desk::PersonPlan.all(person_id: person_id).to_json
  end
end

class FrontListPersonPlans < Pike13BaseTool
  description <<~DESC
    [CLIENT] List customer own membership plans.
    Returns array of customer-visible plan objects with status, benefits, billing dates, and renewal information.
    Use for customer self-service membership viewing.
  DESC

  arguments do
    required(:person_id).filled(:integer).description('Unique Pike13 person ID (integer)')
  end

  def call(person_id:)
    Pike13::Front::PersonPlan.all(person_id: person_id).to_json
  end
end
