# frozen_string_literal: true

require_relative '../base_tool'

class FrontListInvoices < Pike13BaseTool
  description "List customer invoices"

  class << self
    def call(server_context:)
      Pike13::Front::Invoice.all.to_json
    end
  end
end

class FrontGetInvoice < Pike13BaseTool
  description "Get customer invoice"

  input_schema(
    properties: {
      invoice_id: { type: 'integer', description: 'Unique Pike13 invoice ID (integer)' }
    },
    required: ['invoice_id']
  )

  class << self
    def call(invoice_id:, server_context:)
      Pike13::Front::Invoice.find(invoice_id).to_json
    end
  end
end

class FrontGetInvoicePaymentMethods < Pike13BaseTool
  description "Get invoice payment methods"

  input_schema(
    properties: {
      invoice_id: { type: 'integer', description: 'Unique Pike13 invoice ID' }
    },
    required: ['invoice_id']
  )

  class << self
    def call(invoice_id:, server_context:)
      Pike13::Front::Invoice.payment_methods(invoice_id).to_json
    end
  end
end

class FrontCreateInvoice < Pike13BaseTool
  description "Create invoice"

  input_schema(
    properties: {
      person_id: { type: 'integer', description: 'Person ID for the invoice' },
      additional_attributes: { type: 'object', description: 'Optional: Additional invoice attributes as a hash' }
    },
    required: ['person_id']
  )

  class << self
    def call(person_id:, server_context:, additional_attributes: nil)
      attributes = { person_id: person_id }
      attributes.merge!(additional_attributes) if additional_attributes

      Pike13::Front::Invoice.create(attributes).to_json
    end
  end
end

class FrontUpdateInvoice < Pike13BaseTool
  description "Update invoice"

  input_schema(
    properties: {
      invoice_id: { type: 'integer', description: 'Unique Pike13 invoice ID to update' },
      attributes: { type: 'object', description: 'Invoice attributes to update as a hash' }
    },
    required: %w[invoice_id attributes]
  )

  class << self
    def call(invoice_id:, attributes:, server_context:)
      Pike13::Front::Invoice.update(invoice_id, attributes).to_json
    end
  end
end

class FrontCreateInvoiceItem < Pike13BaseTool
  description "Add invoice item"

  input_schema(
    properties: {
      invoice_id: { type: 'integer', description: 'Invoice ID to add item to' },
      description: { type: 'string', description: 'Item description' },
      amount_cents: { type: 'integer', description: 'Item amount in cents' },
      additional_attributes: { type: 'object', description: 'Optional: Additional item attributes' }
    },
    required: %w[invoice_id description amount_cents]
  )

  class << self
    def call(invoice_id:, description:, amount_cents:, server_context:, additional_attributes: nil)
      attributes = {
        description: description,
        amount_cents: amount_cents
      }
      attributes.merge!(additional_attributes) if additional_attributes

      Pike13::Front::Invoice.create_invoice_item(invoice_id, attributes).to_json
    end
  end
end

class FrontDeleteInvoiceItem < Pike13BaseTool
  description "Remove invoice item"

  input_schema(
    properties: {
      invoice_id: { type: 'integer', description: 'Invoice ID' },
      item_id: { type: 'integer', description: 'Invoice item ID to delete' }
    },
    required: %w[invoice_id item_id]
  )

  class << self
    def call(invoice_id:, item_id:, server_context:)
      Pike13::Front::Invoice.destroy_invoice_item(invoice_id, item_id).to_json
    end
  end
end

class FrontCreateInvoicePayment < Pike13BaseTool
  description "Pay invoice"

  input_schema(
    properties: {
      invoice_id: { type: 'integer', description: 'Invoice ID to pay' },
      attributes: { type: 'object', description: 'Payment attributes (amount_cents, form_of_payment_id, etc.)' }
    },
    required: %w[invoice_id attributes]
  )

  class << self
    def call(invoice_id:, attributes:, server_context:)
      Pike13::Front::Invoice.create_payment(invoice_id, attributes).to_json
    end
  end
end

class FrontDeleteInvoicePayment < Pike13BaseTool
  description "Remove invoice payment"

  input_schema(
    properties: {
      invoice_id: { type: 'integer', description: 'Invoice ID' },
      payment_id: { type: 'integer', description: 'Payment ID to delete' }
    },
    required: %w[invoice_id payment_id]
  )

  class << self
    def call(invoice_id:, payment_id:, server_context:)
      Pike13::Front::Invoice.destroy_payment(invoice_id, payment_id).to_json
    end
  end
end
