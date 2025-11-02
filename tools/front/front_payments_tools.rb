# frozen_string_literal: true

require_relative '../base_tool'

class FrontGetPayment < Pike13BaseTool
  description <<~DESC
    Get customer payment details by ID.
    Returns customer-visible payment object with amount, date, payment method last 4 digits, and receipt info.
    Use for customer payment history or receipt display.
  DESC

  input_schema(
    properties: {
      payment_id: { type: 'integer', description: 'Unique Pike13 payment ID (integer)' }
    },
    required: ['payment_id']
  )

  class << self
    def call(payment_id:, server_context:)
      Pike13::Front::Payment.find(payment_id).to_json
    end
  end
end

class FrontGetPaymentConfiguration < Pike13BaseTool
  description <<~DESC
    Get customer-facing payment configuration.
    Returns accepted payment methods, currency, and public payment settings.
    Use for customer payment form setup or displaying payment options.
  DESC

  class << self
    def call(server_context:)
      Pike13::Front::Payment.configuration.to_json
    end
  end
end
