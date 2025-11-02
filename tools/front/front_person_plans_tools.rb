# frozen_string_literal: true

require_relative '../base_tool'

class FrontListPersonPlans < Pike13BaseTool
  description <<~DESC
    List customer own membership plans.
    Returns array of customer-visible plan objects with status, benefits, billing dates, and renewal information.
    Use for customer self-service membership viewing.
  DESC

  input_schema(
    properties: {
      person_id: { type: 'integer', description: 'Unique Pike13 person ID (integer)' }
    },
    required: ['person_id']
  )

  class << self
    def call(person_id:, server_context:)
      Pike13::Front::PersonPlan.all(person_id: person_id).to_json
    end
  end
end
