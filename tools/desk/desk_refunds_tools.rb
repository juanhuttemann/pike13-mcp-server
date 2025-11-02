# frozen_string_literal: true

require_relative "../base_tool"

class DeskVoidRefund < Pike13BaseTool
  description <<~DESC
    [STAFF] Void a refund transaction.

    Voids (cancels) the refund. Returns updated refund with voided_at timestamp and is_voidable=false.

    Use to correct erroneous refunds or handle refund processing errors.

    WARNING: This action cannot be undone and affects financial records.
  DESC

  input_schema(
    properties: {
      refund_id: { type: 'integer', description: 'Unique Pike13 refund ID to void' }
    },
    required: ['refund_id']
  )

  class << self
    def call(refund_id:, server_context:)
      Pike13::Desk::Refund.void(refund_id: refund_id).to_json
    end
  end
end
