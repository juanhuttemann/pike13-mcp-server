# frozen_string_literal: true

require_relative '../base_tool'

class DeskGetPayment < Pike13BaseTool
  description <<~DESC
    Get payment details by ID.
    Returns payment object with amount, payment method, transaction ID, invoice items, status, timestamps, and processing details.
    Use for payment verification, reconciliation, or refund processing.
  DESC

  input_schema(
    properties: {
      payment_id: { type: 'integer', description: 'Unique Pike13 payment ID (integer)' }
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
  description <<~DESC
    Get payment processor configuration.
    Returns payment gateway settings, accepted payment methods, currency, and processing options.
    Use to verify payment setup or troubleshoot payment issues.
  DESC

  class << self
    def call(server_context:)
      Pike13::Desk::Payment.configuration.to_json
    end
  end
end

class DeskVoidPayment < Pike13BaseTool
  description <<~DESC
    Void a payment and optionally cancel specific invoice items.
    Voids the payment transaction and can cancel associated invoice items.
    Returns voided payment object.
    Use to reverse incorrect payments or cancel paid items.
    WARNING: This action cannot be undone.
  DESC

  input_schema(
    properties: {
      payment_id: { type: 'integer', description: 'Unique Pike13 payment ID to void (integer)' },
      invoice_item_ids_to_cancel: { type: 'array',
                                    description: 'Optional: Array of invoice item IDs to cancel with this void' }
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
