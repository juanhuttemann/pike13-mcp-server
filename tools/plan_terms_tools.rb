# frozen_string_literal: true

require_relative 'base_tool'

class FrontListPlanTerms < Pike13BaseTool
  description '[CLIENT] List terms and conditions for a membership plan. Returns array of plan terms objects with version, effective date, terms text, and acceptance status. Use to display plan terms before purchase or signup.'

  arguments do
    required(:plan_id).filled(:integer).description('Unique Pike13 plan ID (integer)')
  end

  def call(plan_id:)
    Pike13::Front::PlanTerms.all(plan_id: plan_id).to_json
  end
end

class FrontGetPlanTerms < Pike13BaseTool
  description '[CLIENT] Get specific version of plan terms and conditions. Returns plan terms object with full terms text, version, effective date, and acceptance requirements. Use to display specific terms version to customer.'

  arguments do
    required(:plan_id).filled(:integer).description('Unique Pike13 plan ID (integer)')
    required(:plan_terms_id).filled(:integer).description('Unique plan terms ID (integer)')
  end

  def call(plan_id:, plan_terms_id:)
    Pike13::Front::PlanTerms.find(plan_id: plan_id, plan_terms_id: plan_terms_id).to_json
  end
end

class FrontCompletePlanTerms < Pike13BaseTool
  description '[CLIENT] Mark plan terms as accepted by customer. Records customer acceptance of terms and conditions. Returns acceptance confirmation. Use after customer reviews and accepts plan terms during signup or renewal.'

  arguments do
    required(:plan_id).filled(:integer).description('Unique Pike13 plan ID (integer)')
    required(:plan_terms_id).filled(:integer).description('Unique plan terms ID to accept (integer)')
  end

  def call(plan_id:, plan_terms_id:)
    Pike13::Front::PlanTerms.complete(plan_id: plan_id, plan_terms_id: plan_terms_id).to_json
  end
end
