# frozen_string_literal: true

require_relative '../base_tool'

class DeskListPlans < Pike13BaseTool
  description "List plans"

  input_schema(
    properties: {
      include_holds: { type: 'boolean', description: 'Include holds' }
    },
    required: []
  )

  class << self
    def call(server_context:, include_holds: nil)
      params = {}
      params[:include_holds] = include_holds if include_holds
      Pike13::Desk::Plan.all(**params).to_json
    end
  end
end

class DeskUpdatePlanEndDate < Pike13BaseTool
  description "Update plan end date"

  input_schema(
    properties: {
      plan_id: { type: 'integer', description: 'Plan ID' },
      end_date: { type: 'string', description: 'End date (YYYY-MM-DD)' }
    },
    required: %w[plan_id end_date]
  )

  class << self
    def call(plan_id:, end_date:, server_context:)
      params = { end_date: end_date }
      Pike13::Desk::Plan.update_end_date(plan_id, params).to_json
    end
  end
end
