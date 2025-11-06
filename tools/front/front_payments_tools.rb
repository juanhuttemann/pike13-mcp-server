# frozen_string_literal: true

require_relative '../base_tool'

class FrontGetPayment < Pike13BaseTool
  description "Get customer payment"

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
  description "Get payment config"

  class << self
    def call(server_context:)
      Pike13::Front::Payment.configuration.to_json
    end
  end
end
