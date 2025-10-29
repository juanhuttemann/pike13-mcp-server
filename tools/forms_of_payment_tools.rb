# frozen_string_literal: true

require_relative 'base_tool'

class DeskListFormsOfPayment < Pike13BaseTool
  description '[STAFF] List all saved payment methods for a person. Returns array of form of payment objects with type (credit card/ACH), last 4 digits, expiration, billing address, and default status. Use for billing management, payment troubleshooting, or customer service.'

  arguments do
    required(:person_id).filled(:integer).description('Unique Pike13 person ID (integer)')
  end

  def call(person_id:)
    Pike13::Desk::FormOfPayment.all(person_id: person_id).to_json
  end
end

class DeskGetFormOfPayment < Pike13BaseTool
  description '[STAFF] Get specific payment method details. Returns form of payment object with type, last 4 digits, expiration, billing address, and metadata. Use for payment verification or billing inquiries.'

  arguments do
    required(:person_id).filled(:integer).description('Unique Pike13 person ID (integer)')
    required(:form_of_payment_id).filled(:integer).description('Unique form of payment ID (integer)')
  end

  def call(person_id:, form_of_payment_id:)
    Pike13::Desk::FormOfPayment.find(person_id: person_id, id: form_of_payment_id).to_json
  end
end

class DeskCreateFormOfPayment < Pike13BaseTool
  description '[STAFF] Add new payment method for a person. Requires "type" parameter ("creditcard" or "ach") and payment token from payment processor. Returns created form of payment object. Use for adding customer payment methods. WARNING: Must include "type" field ("creditcard" or "ach").'

  arguments do
    required(:person_id).filled(:integer).description('Unique Pike13 person ID (integer)')
    required(:type).filled(:string).description('Payment type: "creditcard" or "ach" (REQUIRED)')
    required(:token).filled(:string).description('Payment processor token (from Stripe, etc.)')
    optional(:additional_attributes).maybe(:hash).description('Optional: Additional attributes (billing address, is_default, etc.)')
  end

  def call(person_id:, type:, token:, additional_attributes: nil)
    attributes = {
      type: type,
      token: token
    }
    attributes.merge!(additional_attributes) if additional_attributes

    Pike13::Desk::FormOfPayment.create(person_id: person_id, attributes: attributes).to_json
  end
end

class DeskUpdateFormOfPayment < Pike13BaseTool
  description '[STAFF] Update existing payment method. Updates only provided fields. Returns updated form of payment object. Use for updating billing address, setting default payment method, or updating expiration.'

  arguments do
    required(:person_id).filled(:integer).description('Unique Pike13 person ID (integer)')
    required(:form_of_payment_id).filled(:integer).description('Unique form of payment ID to update (integer)')
    optional(:attributes).maybe(:hash).description('Optional: Attributes to update (is_default, billing_address, etc.)')
  end

  def call(person_id:, form_of_payment_id:, attributes: nil)
    Pike13::Desk::FormOfPayment.update(
      person_id: person_id,
      id: form_of_payment_id,
      attributes: attributes || {}
    ).to_json
  end
end

class DeskDeleteFormOfPayment < Pike13BaseTool
  description '[STAFF] Delete a payment method. Removes the saved payment method. Returns success status. Use to remove expired cards or at customer request. WARNING: Cannot delete if it is the default payment method for active subscriptions.'

  arguments do
    required(:person_id).filled(:integer).description('Unique Pike13 person ID (integer)')
    required(:form_of_payment_id).filled(:integer).description('Unique form of payment ID to delete (integer)')
  end

  def call(person_id:, form_of_payment_id:)
    Pike13::Desk::FormOfPayment.destroy(person_id: person_id, id: form_of_payment_id).to_json
  end
end

class FrontListFormsOfPayment < Pike13BaseTool
  description '[CLIENT] List customer own saved payment methods. Returns array of customer-visible payment method objects with masked card numbers and expiration dates. Use for customer self-service payment management.'

  arguments do
    required(:person_id).filled(:integer).description('Unique Pike13 person ID (integer)')
  end

  def call(person_id:)
    Pike13::Front::FormOfPayment.all(person_id: person_id).to_json
  end
end

class FrontGetFormOfPayment < Pike13BaseTool
  description '[CLIENT] Get specific customer payment method details. Returns customer-visible form of payment object. Use for customer payment method viewing.'

  arguments do
    required(:person_id).filled(:integer).description('Unique Pike13 person ID (integer)')
    required(:form_of_payment_id).filled(:integer).description('Unique form of payment ID (integer)')
  end

  def call(person_id:, form_of_payment_id:)
    Pike13::Front::FormOfPayment.find(person_id: person_id, id: form_of_payment_id).to_json
  end
end

class FrontGetFormOfPaymentMe < Pike13BaseTool
  description '[CLIENT] Get authenticated customer own payment method by ID. Returns payment method for the currently authenticated customer. Use for customer self-service payment viewing without requiring person_id.'

  arguments do
    required(:form_of_payment_id).filled(:integer).description('Unique form of payment ID (integer)')
  end

  def call(form_of_payment_id:)
    Pike13::Front::FormOfPayment.find_me(id: form_of_payment_id).to_json
  end
end

class FrontCreateFormOfPayment < Pike13BaseTool
  description '[CLIENT] Add new payment method for customer. Requires "type" parameter ("creditcard" or "ach") and payment token. Returns created form of payment object. Use for customer self-service payment method addition. WARNING: Must include "type" field ("creditcard" or "ach").'

  arguments do
    required(:person_id).filled(:integer).description('Unique Pike13 person ID (integer)')
    required(:type).filled(:string).description('Payment type: "creditcard" or "ach" (REQUIRED)')
    required(:token).filled(:string).description('Payment processor token (from Stripe, etc.)')
    optional(:additional_attributes).maybe(:hash).description('Optional: Additional attributes (billing address, is_default, etc.)')
  end

  def call(person_id:, type:, token:, additional_attributes: nil)
    attributes = {
      type: type,
      token: token
    }
    attributes.merge!(additional_attributes) if additional_attributes

    Pike13::Front::FormOfPayment.create(person_id: person_id, attributes: attributes).to_json
  end
end

class FrontUpdateFormOfPayment < Pike13BaseTool
  description '[CLIENT] Update customer own payment method. Updates only provided fields. Returns updated form of payment object. Use for customer self-service payment method updates.'

  arguments do
    required(:person_id).filled(:integer).description('Unique Pike13 person ID (integer)')
    required(:form_of_payment_id).filled(:integer).description('Unique form of payment ID to update (integer)')
    optional(:attributes).maybe(:hash).description('Optional: Attributes to update (is_default, billing_address, etc.)')
  end

  def call(person_id:, form_of_payment_id:, attributes: nil)
    Pike13::Front::FormOfPayment.update(
      person_id: person_id,
      id: form_of_payment_id,
      attributes: attributes || {}
    ).to_json
  end
end

class FrontDeleteFormOfPayment < Pike13BaseTool
  description '[CLIENT] Delete customer own payment method. Removes the saved payment method. Returns success status. Use for customer self-service payment method removal. WARNING: Cannot delete if it is the default payment method for active subscriptions.'

  arguments do
    required(:person_id).filled(:integer).description('Unique Pike13 person ID (integer)')
    required(:form_of_payment_id).filled(:integer).description('Unique form of payment ID to delete (integer)')
  end

  def call(person_id:, form_of_payment_id:)
    Pike13::Front::FormOfPayment.destroy(person_id: person_id, id: form_of_payment_id).to_json
  end
end
