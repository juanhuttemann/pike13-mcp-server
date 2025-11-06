# frozen_string_literal: true

require_relative '../base_tool'

class DeskVoidRefund < Pike13BaseTool
  description "Void refund"

  input_schema(
    properties: {
      refund_id: { type: 'integer', description: 'Refund ID' }
    },
    required: ['refund_id']
  )

  class << self
    def call(refund_id:, server_context:)
      Pike13::Desk::Refund.void(refund_id: refund_id).to_json
    end
  end
end
