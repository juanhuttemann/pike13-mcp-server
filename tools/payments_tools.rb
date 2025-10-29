# frozen_string_literal: true

require_relative 'base_tool'

class DeskGetPayment < Pike13BaseTool
  description '[STAFF] Get payment details by ID. Returns payment object with amount, payment method, transaction ID, invoice items, status, timestamps, and processing details. Use for payment verification, reconciliation, or refund processing.'

  arguments do
    required(:payment_id).filled(:integer).description('Unique Pike13 payment ID (integer)')
  end

  def call(payment_id:)
    Pike13::Desk::Payment.find(payment_id).to_json
  end
end

class DeskGetPaymentConfiguration < Pike13BaseTool
  description '[STAFF] Get payment processor configuration. Returns payment gateway settings, accepted payment methods, currency, and processing options. Use to verify payment setup or troubleshoot payment issues.'

  def call
    Pike13::Desk::Payment.configuration.to_json
  end
end

class DeskVoidPayment < Pike13BaseTool
  description '[STAFF] Void a payment and optionally cancel specific invoice items. Voids the payment transaction and can cancel associated invoice items. Returns voided payment object. Use to reverse incorrect payments or cancel paid items. WARNING: This action cannot be undone.'

  arguments do
    required(:payment_id).filled(:integer).description('Unique Pike13 payment ID to void (integer)')
    optional(:invoice_item_ids_to_cancel).maybe(:array).description('Optional: Array of invoice item IDs to cancel with this void')
  end

  def call(payment_id:, invoice_item_ids_to_cancel: nil)
    params = { payment_id: payment_id }
    params[:invoice_item_ids_to_cancel] = invoice_item_ids_to_cancel if invoice_item_ids_to_cancel

    Pike13::Desk::Payment.void(**params).to_json
  end
end

class FrontGetPayment < Pike13BaseTool
  description '[CLIENT] Get customer payment details by ID. Returns customer-visible payment object with amount, date, payment method last 4 digits, and receipt info. Use for customer payment history or receipt display.'

  arguments do
    required(:payment_id).filled(:integer).description('Unique Pike13 payment ID (integer)')
  end

  def call(payment_id:)
    Pike13::Front::Payment.find(payment_id).to_json
  end
end

class FrontGetPaymentConfiguration < Pike13BaseTool
  description '[CLIENT] Get customer-facing payment configuration. Returns accepted payment methods, currency, and public payment settings. Use for customer payment form setup or displaying payment options.'

  def call
    Pike13::Front::Payment.configuration.to_json
  end
end
