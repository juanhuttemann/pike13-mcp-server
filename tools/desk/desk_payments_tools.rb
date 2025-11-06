# frozen_string_literal: true

require_relative '../base_tool'

class DeskGetPayment < Pike13BaseTool
  description "Get payment"

  input_schema(
    properties: {
      payment_id: { type: 'integer', description: 'Payment ID' }
    },
    required: ['payment_id']
  )

  class << self
    def call(payment_id:, server_context:)
      Pike13::Desk::Payment.find(payment_id).to_json
    end
  end
end

class DeskGetPaymentConfiguration < Pike13BaseTool
  description "Get payment configuration"

  class << self
    def call(server_context:)
      Pike13::Desk::Payment.configuration.to_json
    end
  end
end

class DeskVoidPayment < Pike13BaseTool
  description "Void payment"

  input_schema(
    properties: {
      payment_id: { type: 'integer', description: 'Payment ID' },
      invoice_item_ids_to_cancel: { type: 'array', description: 'Invoice item IDs to cancel' }
    },
    required: ['payment_id']
  )

  class << self
    def call(payment_id:, server_context:, invoice_item_ids_to_cancel: nil)
      params = { payment_id: payment_id }
      params[:invoice_item_ids_to_cancel] = invoice_item_ids_to_cancel if invoice_item_ids_to_cancel

      Pike13::Desk::Payment.void(**params).to_json
    end
  end
end
