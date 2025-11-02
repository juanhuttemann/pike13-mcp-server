# frozen_string_literal: true

require_relative 'base_tool'

class FrontListPlanTerms < Pike13BaseTool
  description <<~DESC
    List terms and conditions for a membership plan.
    Returns array of plan terms objects with version, effective date, terms text, and acceptance status.
    Use to display plan terms before purchase or signup.
  DESC

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
  description <<~DESC
    Get specific version of plan terms and conditions.
    Returns plan terms object with full terms text, version, effective date, and acceptance requirements.
    Use to display specific terms version to customer.
  DESC

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
  description <<~DESC
    Mark plan terms as accepted by customer.
    Records customer acceptance of terms and conditions.
    Returns acceptance confirmation.
    Use after customer reviews and accepts plan terms during signup or renewal.
  DESC

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
