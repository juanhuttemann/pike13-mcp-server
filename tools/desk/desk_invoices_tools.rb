# frozen_string_literal: true

require_relative '../base_tool'

class DeskListInvoices < Pike13BaseTool
  description "List invoices"

  class << self
    def call(server_context:)
      Pike13::Desk::Invoice.all.to_json
    end
  end
end

class DeskGetInvoice < Pike13BaseTool
  description "Get invoice"

  input_schema(
    properties: {
      invoice_id: { type: 'integer', description: 'Invoice ID' }
    },
    required: ['invoice_id']
  )

  class << self
    def call(invoice_id:, server_context:)
      Pike13::Desk::Invoice.find(invoice_id).to_json
    end
  end
end

class DeskGetInvoicePaymentMethods < Pike13BaseTool
  description "Get invoice payment methods"

  input_schema(
    properties: {
      invoice_id: { type: 'integer', description: 'Invoice ID' }
    },
    required: ['invoice_id']
  )

  class << self
    def call(invoice_id:, server_context:)
      Pike13::Desk::Invoice.payment_methods(invoice_id).to_json
    end
  end
end

class DeskCreateInvoice < Pike13BaseTool
  description "Create invoice"

  input_schema(
    properties: {
      person_id: { type: 'integer', description: 'Person ID for the invoice' },
      additional_attributes: { type: 'object', description: 'Optional: Additional attributes' }
    },
    required: ['person_id']
  )

  class << self
    def call(person_id:, server_context:, additional_attributes: nil)
      attributes = { person_id: person_id }
      attributes.merge!(additional_attributes) if additional_attributes

      Pike13::Desk::Invoice.create(attributes).to_json
    end
  end
end

class DeskUpdateInvoice < Pike13BaseTool
  description "Update invoice"

  input_schema(
    properties: {
      invoice_id: { type: 'integer', description: 'Invoice ID' },
      attributes: { type: 'object', description: 'Invoice attributes to update as a hash' }
    },
    required: %w[invoice_id attributes]
  )

  class << self
    def call(invoice_id:, attributes:, server_context:)
      Pike13::Desk::Invoice.update(invoice_id, attributes).to_json
    end
  end
end

class DeskCreateInvoiceItem < Pike13BaseTool
  description "Create invoice item"

  input_schema(
    properties: {
      invoice_id: { type: 'integer', description: 'Invoice ID to add item to' },
      description: { type: 'string', description: 'Item description' },
      amount_cents: { type: 'integer', description: 'Item amount in cents' },
      additional_attributes: { type: 'object', description: 'Optional: Additional attributes' }
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

      Pike13::Desk::Invoice.create_invoice_item(invoice_id, attributes).to_json
    end
  end
end

class DeskDeleteInvoiceItem < Pike13BaseTool
  description "Delete invoice item"

  input_schema(
    properties: {
      invoice_id: { type: 'integer', description: 'Invoice ID' },
      item_id: { type: 'integer', description: 'Invoice item ID to delete' }
    },
    required: %w[invoice_id item_id]
  )

  class << self
    def call(invoice_id:, item_id:, server_context:)
      Pike13::Desk::Invoice.destroy_invoice_item(invoice_id, item_id).to_json
    end
  end
end

class DeskCreateInvoiceItemDiscount < Pike13BaseTool
  description "Create invoice item discount"

  input_schema(
    properties: {
      invoice_id: { type: 'integer', description: 'Invoice ID' },
      invoice_item_id: { type: 'integer', description: 'Invoice item ID to discount' },
      attributes: { type: 'object', description: 'Discount attributes (amount_cents or percentage)' }
    },
    required: %w[invoice_id invoice_item_id attributes]
  )

  class << self
    def call(invoice_id:, invoice_item_id:, attributes:, server_context:)
      Pike13::Desk::Invoice.create_discount(invoice_id, invoice_item_id, attributes).to_json
    end
  end
end

class DeskGetInvoiceItemDiscounts < Pike13BaseTool
  description "Get invoice item discounts"

  input_schema(
    properties: {
      invoice_id: { type: 'integer', description: 'Invoice ID' },
      invoice_item_id: { type: 'integer', description: 'Invoice item ID' }
    },
    required: %w[invoice_id invoice_item_id]
  )

  class << self
    def call(invoice_id:, invoice_item_id:, server_context:)
      Pike13::Desk::Invoice.discounts(invoice_id, invoice_item_id).to_json
    end
  end
end

class DeskDeleteInvoiceItemDiscounts < Pike13BaseTool
  description "Delete invoice item discounts"

  input_schema(
    properties: {
      invoice_id: { type: 'integer', description: 'Invoice ID' },
      invoice_item_id: { type: 'integer', description: 'Invoice item ID' }
    },
    required: %w[invoice_id invoice_item_id]
  )

  class << self
    def call(invoice_id:, invoice_item_id:, server_context:)
      Pike13::Desk::Invoice.destroy_discounts(invoice_id, invoice_item_id).to_json
    end
  end
end

class DeskCreateInvoiceItemProrate < Pike13BaseTool
  description "Create invoice item prorate"

  input_schema(
    properties: {
      invoice_id: { type: 'integer', description: 'Invoice ID' },
      invoice_item_id: { type: 'integer', description: 'Invoice item ID to prorate' },
      attributes: { type: 'object', description: 'Prorate attributes' }
    },
    required: %w[invoice_id invoice_item_id attributes]
  )

  class << self
    def call(invoice_id:, invoice_item_id:, attributes:, server_context:)
      Pike13::Desk::Invoice.create_prorate(invoice_id, invoice_item_id, attributes).to_json
    end
  end
end

class DeskDeleteInvoiceItemProrate < Pike13BaseTool
  description "Delete invoice item prorate"

  input_schema(
    properties: {
      invoice_id: { type: 'integer', description: 'Invoice ID' },
      invoice_item_id: { type: 'integer', description: 'Invoice item ID' }
    },
    required: %w[invoice_id invoice_item_id]
  )

  class << self
    def call(invoice_id:, invoice_item_id:, server_context:)
      Pike13::Desk::Invoice.destroy_prorate(invoice_id, invoice_item_id).to_json
    end
  end
end

class DeskCreateInvoicePayment < Pike13BaseTool
  description "Create invoice payment"

  input_schema(
    properties: {
      invoice_id: { type: 'integer', description: 'Invoice ID to pay' },
      attributes: { type: 'object', description: 'Payment attributes' }
    },
    required: %w[invoice_id attributes]
  )

  class << self
    def call(invoice_id:, attributes:, server_context:)
      Pike13::Desk::Invoice.create_payment(invoice_id, attributes).to_json
    end
  end
end

class DeskCreateInvoiceRefund < Pike13BaseTool
  description "Create invoice refund"

  input_schema(
    properties: {
      invoice_id: { type: 'integer', description: 'Invoice ID' },
      payment_id: { type: 'integer', description: 'Payment ID to refund' },
      attributes: { type: 'object', description: 'Refund attributes' }
    },
    required: %w[invoice_id payment_id attributes]
  )

  class << self
    def call(invoice_id:, payment_id:, attributes:, server_context:)
      Pike13::Desk::Invoice.create_refund(invoice_id, payment_id, attributes).to_json
    end
  end
end
