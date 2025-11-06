# frozen_string_literal: true

require_relative '../base_tool'

class FrontListPlanTerms < Pike13BaseTool
  description "List plan terms"

  input_schema(
    properties: {
      plan_id: { type: 'integer', description: 'Unique Pike13 plan ID (integer)' }
    },
    required: ['plan_id']
  )

  class << self
    def call(plan_id:, server_context:)
      Pike13::Front::PlanTerms.all(plan_id: plan_id).to_json
    end
  end
end

class FrontGetPlanTerms < Pike13BaseTool
  description "Get plan terms"

  input_schema(
    properties: {
      plan_id: { type: 'integer', description: 'Unique Pike13 plan ID (integer)' },
      plan_terms_id: { type: 'integer', description: 'Unique plan terms ID (integer)' }
    },
    required: %w[plan_id plan_terms_id]
  )

  class << self
    def call(plan_id:, plan_terms_id:, server_context:)
      Pike13::Front::PlanTerms.find(plan_id: plan_id, plan_terms_id: plan_terms_id).to_json
    end
  end
end

class FrontCompletePlanTerms < Pike13BaseTool
  description "Accept plan terms"

  input_schema(
    properties: {
      plan_id: { type: 'integer', description: 'Unique Pike13 plan ID (integer)' },
      plan_terms_id: { type: 'integer', description: 'Unique plan terms ID to accept (integer)' }
    },
    required: %w[plan_id plan_terms_id]
  )

  class << self
    def call(plan_id:, plan_terms_id:, server_context:)
      Pike13::Front::PlanTerms.complete(plan_id: plan_id, plan_terms_id: plan_terms_id).to_json
    end
  end
end
