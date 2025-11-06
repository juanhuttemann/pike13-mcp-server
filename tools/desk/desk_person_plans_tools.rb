# frozen_string_literal: true

require_relative '../base_tool'

class DeskListPersonPlans < Pike13BaseTool
  description "List person plans"

  input_schema(
    properties: {
      person_id: { type: 'integer', description: 'Unique Pike13 person ID (integer)' }
    },
    required: ['person_id']
  )

  class << self
    def call(person_id:, server_context:)
      Pike13::Desk::PersonPlan.all(person_id: person_id).to_json
    end
  end
end
