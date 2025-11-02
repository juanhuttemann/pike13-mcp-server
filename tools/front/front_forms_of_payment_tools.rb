# frozen_string_literal: true

require_relative '../base_tool'

class FrontListFormsOfPayment < Pike13BaseTool
  description <<~DESC
    List customer own saved payment methods.
    Returns array of customer-visible payment method objects with masked card numbers and expiration dates.
    Use for customer self-service payment management.
  DESC

  input_schema(
    properties: {
      person_id: { type: 'integer', description: 'Unique Pike13 person ID (integer)' }
    },
    required: ['person_id']
  )

  class << self
    def call(person_id:, server_context:)
      Pike13::Front::FormOfPayment.all(person_id: person_id).to_json
    end
  end
end

class FrontGetFormOfPayment < Pike13BaseTool
  description <<~DESC
    Get specific customer payment method details.
    Returns customer-visible form of payment object.
    Use for customer payment method viewing.
  DESC

  input_schema(
    properties: {
      person_id: { type: 'integer', description: 'Unique Pike13 person ID (integer)' },
      form_of_payment_id: { type: 'integer', description: 'Unique form of payment ID (integer)' }
    },
    required: %w[person_id form_of_payment_id]
  )

  class << self
    def call(person_id:, form_of_payment_id:, server_context:)
      Pike13::Front::FormOfPayment.find(person_id: person_id, id: form_of_payment_id).to_json
    end
  end
end

class FrontGetFormOfPaymentMe < Pike13BaseTool
  description <<~DESC
    Get authenticated customer own payment method by ID.
    Returns payment method for the currently authenticated customer.
    Use for customer self-service payment viewing without requiring person_id.
  DESC

  input_schema(
    properties: {
      form_of_payment_id: { type: 'integer', description: 'Unique form of payment ID (integer)' }
    },
    required: ['form_of_payment_id']
  )

  class << self
    def call(form_of_payment_id:, server_context:)
      Pike13::Front::FormOfPayment.find_me(id: form_of_payment_id).to_json
    end
  end
end

class FrontCreateFormOfPayment < Pike13BaseTool
  description <<~DESC
    Add new payment method for customer.
    Requires "type" parameter ("creditcard" or "ach") and payment token.
    Returns created form of payment object.
    Use for customer self-service payment method addition.
    WARNING: Must include "type" field ("creditcard" or "ach").
  DESC

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

      Pike13::Front::FormOfPayment.create(person_id: person_id, attributes: attributes).to_json
    end
  end
end

class FrontUpdateFormOfPayment < Pike13BaseTool
  description <<~DESC
    Update customer own payment method.
    Updates only provided fields.
    Returns updated form of payment object.
    Use for customer self-service payment method updates.
  DESC

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
      Pike13::Front::FormOfPayment.update(
        person_id: person_id,
        id: form_of_payment_id,
        attributes: attributes || {}
      ).to_json
    end
  end
end

class FrontDeleteFormOfPayment < Pike13BaseTool
  description <<~DESC
    Delete customer own payment method.
    Removes the saved payment method.
    Returns success status.
    Use for customer self-service payment method removal.
    WARNING: Cannot delete if it is the default payment method for active subscriptions.
  DESC

  input_schema(
    properties: {
      person_id: { type: 'integer', description: 'Unique Pike13 person ID (integer)' },
      form_of_payment_id: { type: 'integer', description: 'Unique form of payment ID to delete (integer)' }
    },
    required: %w[person_id form_of_payment_id]
  )

  class << self
    def call(person_id:, form_of_payment_id:, server_context:)
      Pike13::Front::FormOfPayment.destroy(person_id: person_id, id: form_of_payment_id).to_json
    end
  end
end
