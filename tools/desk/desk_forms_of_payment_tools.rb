# frozen_string_literal: true

require_relative '../base_tool'

class DeskListFormsOfPayment < Pike13BaseTool
  description "List person payment methods"

  input_schema(
    properties: {
      person_id: { type: 'integer', description: 'Unique Pike13 person ID (integer)' }
    },
    required: ['person_id']
  )

  class << self
    def call(person_id:, server_context:)
      Pike13::Desk::FormOfPayment.all(person_id: person_id).to_json
    end
  end
end

class DeskGetFormOfPayment < Pike13BaseTool
  description "Get payment method details"

  input_schema(
    properties: {
      person_id: { type: 'integer', description: 'Unique Pike13 person ID (integer)' },
      form_of_payment_id: { type: 'integer', description: 'Unique form of payment ID (integer)' }
    },
    required: %w[person_id form_of_payment_id]
  )

  class << self
    def call(person_id:, form_of_payment_id:, server_context:)
      Pike13::Desk::FormOfPayment.find(person_id: person_id, id: form_of_payment_id).to_json
    end
  end
end

class DeskCreateFormOfPayment < Pike13BaseTool
  description "Create payment method - requires type and token"

  input_schema(
    properties: {
      person_id: { type: 'integer', description: 'Unique Pike13 person ID (integer)' },
      type: { type: 'string', description: 'Payment type: "creditcard" or "ach" (REQUIRED)' },
      token: { type: 'string', description: 'Payment processor token (from Stripe, etc.)' },
      additional_attributes: { type: 'object',
                               description: 'Optional: Additional attributes (billing address, is_default, etc.)' }
    },
    required: %w[person_id type token]
  )

  class << self
    def call(person_id:, type:, token:, server_context:, additional_attributes: nil)
      attributes = {
        type: type,
        token: token
      }
      attributes.merge!(additional_attributes) if additional_attributes

      Pike13::Desk::FormOfPayment.create(person_id: person_id, attributes: attributes).to_json
    end
  end
end

class DeskUpdateFormOfPayment < Pike13BaseTool
  description "Update payment method"

  input_schema(
    properties: {
      person_id: { type: 'integer', description: 'Unique Pike13 person ID (integer)' },
      form_of_payment_id: { type: 'integer', description: 'Unique form of payment ID to update (integer)' },
      attributes: { type: 'object', description: 'Optional: Attributes to update (is_default, billing_address, etc.)' }
    },
    required: %w[person_id form_of_payment_id]
  )

  class << self
    def call(person_id:, form_of_payment_id:, server_context:, attributes: nil)
      Pike13::Desk::FormOfPayment.update(
        person_id: person_id,
        id: form_of_payment_id,
        attributes: attributes || {}
      ).to_json
    end
  end
end

class DeskDeleteFormOfPayment < Pike13BaseTool
  description "Delete payment method"

  input_schema(
    properties: {
      person_id: { type: 'integer', description: 'Unique Pike13 person ID (integer)' },
      form_of_payment_id: { type: 'integer', description: 'Unique form of payment ID to delete (integer)' }
    },
    required: %w[person_id form_of_payment_id]
  )

  class << self
    def call(person_id:, form_of_payment_id:, server_context:)
      Pike13::Desk::FormOfPayment.destroy(person_id: person_id, id: form_of_payment_id).to_json
    end
  end
end
