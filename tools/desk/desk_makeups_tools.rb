# frozen_string_literal: true

require_relative '../base_tool'

class DeskListMakeUpReasons < Pike13BaseTool
  description "List make-up reasons"

  class << self
    def call(server_context:)
      Pike13::Desk::MakeUp.reasons.to_json
    end
  end
end

class DeskGenerateMakeUp < Pike13BaseTool
  description "Creates a make up pass to a canceled enrollment."

  input_schema(
    properties: {
      visit_id: { type: 'integer', description: 'Unique Pike13 visit ID to generate make-up for (integer)' },
      make_up_reason_id: { type: 'integer', description: 'Make-up reason ID (get from DeskListMakeUpReasons)' },
      free_form_reason: { type: 'string', description: 'Optional: Additional free-form text explaining the reason' }
    },
    required: %w[visit_id make_up_reason_id]
  )

  class << self
    def call(visit_id:, make_up_reason_id:, server_context:, free_form_reason: nil)
      params = {
        visit_id: visit_id,
        make_up_reason_id: make_up_reason_id
      }
      params[:free_form_reason] = free_form_reason if free_form_reason

      Pike13::Desk::MakeUp.generate(**params).to_json
    end
  end
end
