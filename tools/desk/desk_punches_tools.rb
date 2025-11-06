# frozen_string_literal: true

require_relative '../base_tool'

class DeskGetPunch < Pike13BaseTool
  description "Get punch"

  input_schema(
    properties: {
      punch_id: { type: 'integer', description: 'Unique Pike13 punch ID' }
    },
    required: ['punch_id']
  )

  class << self
    def call(punch_id:, server_context:)
      Pike13::Desk::Punch.find(punch_id).to_json
    end
  end
end

class DeskCreatePunch < Pike13BaseTool
  description "Create punch"

  input_schema(
    properties: {
      visit_id: { type: 'integer', description: 'Visit ID to pay for' },
      plan_id: { type: 'integer', description: 'Optional: plan ID to use (auto-selected if omitted)' }
    },
    required: ['visit_id']
  )

  class << self
    def call(visit_id:, server_context:, plan_id: nil)
      params = { visit_id: visit_id }
      params[:plan_id] = plan_id if plan_id
      Pike13::Desk::Punch.create(params).to_json
    end
  end
end

class DeskDeletePunch < Pike13BaseTool
  description "Delete punch"

  input_schema(
    properties: {
      punch_id: { type: 'integer', description: 'Punch ID to delete' }
    },
    required: ['punch_id']
  )

  class << self
    def call(punch_id:, server_context:)
      Pike13::Desk::Punch.delete(punch_id).to_json
    end
  end
end
