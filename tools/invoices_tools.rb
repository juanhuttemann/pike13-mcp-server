# frozen_string_literal: true

require_relative 'base_tool'

# Front (CLIENT) Invoice Tools

class FrontListInvoices < Pike13BaseTool
  description <<~DESC
    [CLIENT] List customer invoices.
    Returns invoices for authenticated customer with line items, amounts, and payment status.
    Use to show customer their billing history.
  DESC

  class << self
    def call(server_context:)
      Pike13::Front::Invoice.all.to_json
    end
  end
end

class FrontGetInvoice < Pike13BaseTool
  description <<~DESC
    [CLIENT] Get customer invoice by ID.
    Returns invoice with line items, amounts, taxes, payment status, and due date.
    Use to show customers their bills or payment history.
    Only returns invoices for authenticated customer.
  DESC

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
  description <<~DESC
    [CLIENT] Get available payment methods for an invoice.
    Returns payment methods that can be used to pay this invoice.
    Use when customer is ready to pay an invoice.
  DESC

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
  description <<~DESC
    [CLIENT] Create a new invoice.
    Creates invoice for authenticated customer.
    Returns created invoice with ID.
  DESC

  input_schema(
    properties: {
      person_id: { type: 'integer', description: 'Person ID for the invoice' },
      additional_attributes: { type: 'object', description: 'Optional: Additional invoice attributes as a hash' }
    },
    required: ['person_id']
  )

  class << self
    def call(person_id:, additional_attributes: nil, server_context:)
      attributes = { person_id: person_id }
      attributes.merge!(additional_attributes) if additional_attributes

      Pike13::Front::Invoice.create(attributes).to_json
    end
  end
end

class FrontUpdateInvoice < Pike13BaseTool
  description <<~DESC
    [CLIENT] Update an existing invoice.
    Updates invoice details like due date or notes.
    Returns updated invoice.
  DESC

  input_schema(
    properties: {
      invoice_id: { type: 'integer', description: 'Unique Pike13 invoice ID to update' },
      attributes: { type: 'object', description: 'Invoice attributes to update as a hash' }
    },
    required: ['invoice_id', 'attributes']
  )

  class << self
    def call(invoice_id:, attributes:, server_context:)
      Pike13::Front::Invoice.update(invoice_id, attributes).to_json
    end
  end
end

class FrontCreateInvoiceItem < Pike13BaseTool
  description <<~DESC
    [CLIENT] Add an item to an invoice.
    Creates a new line item on the invoice.
    Returns updated invoice with new item.
  DESC

  input_schema(
    properties: {
      invoice_id: { type: 'integer', description: 'Invoice ID to add item to' },
      description: { type: 'string', description: 'Item description' },
      amount_cents: { type: 'integer', description: 'Item amount in cents' },
      additional_attributes: { type: 'object', description: 'Optional: Additional item attributes' }
    },
    required: ['invoice_id', 'description', 'amount_cents']
  )

  class << self
    def call(invoice_id:, description:, amount_cents:, additional_attributes: nil, server_context:)
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
  description <<~DESC
    [CLIENT] Remove an item from an invoice.
    Deletes a line item from the invoice.
    Returns updated invoice.
  DESC

  input_schema(
    properties: {
      invoice_id: { type: 'integer', description: 'Invoice ID' },
      item_id: { type: 'integer', description: 'Invoice item ID to delete' }
    },
    required: ['invoice_id', 'item_id']
  )

  class << self
    def call(invoice_id:, item_id:, server_context:)
      Pike13::Front::Invoice.destroy_invoice_item(invoice_id, item_id).to_json
    end
  end
end

class FrontCreateInvoicePayment < Pike13BaseTool
  description <<~DESC
    [CLIENT] Create a payment for an invoice.
    Processes payment for the invoice using specified payment method.
    Returns payment confirmation.
  DESC

  input_schema(
    properties: {
      invoice_id: { type: 'integer', description: 'Invoice ID to pay' },
      attributes: { type: 'object', description: 'Payment attributes (amount_cents, form_of_payment_id, etc.)' }
    },
    required: ['invoice_id', 'attributes']
  )

  class << self
    def call(invoice_id:, attributes:, server_context:)
      Pike13::Front::Invoice.create_payment(invoice_id, attributes).to_json
    end
  end
end

class FrontDeleteInvoicePayment < Pike13BaseTool
  description <<~DESC
    [CLIENT] Delete a payment from an invoice.
    Removes a payment from the invoice (if allowed).
    Returns updated invoice.
  DESC

  input_schema(
    properties: {
      invoice_id: { type: 'integer', description: 'Invoice ID' },
      payment_id: { type: 'integer', description: 'Payment ID to delete' }
    },
    required: ['invoice_id', 'payment_id']
  )

  class << self
    def call(invoice_id:, payment_id:, server_context:)
      Pike13::Front::Invoice.destroy_payment(invoice_id, payment_id).to_json
    end
  end
end

# Desk (STAFF) Invoice Tools

class DeskListInvoices < Pike13BaseTool
  description <<~DESC
    [STAFF] List ALL invoices - AVOID for searches.
    Returns huge dataset.
    Use ONLY for "all invoices", "financial report", "accounts receivable".
    For specific customer invoices, search person first then get their invoices.
  DESC

  class << self
    def call(server_context:)
      Pike13::Desk::Invoice.all.to_json
    end
  end
end

class DeskGetInvoice < Pike13BaseTool
  description <<~DESC
    [STAFF] Get invoice by ID with full admin details.
    Returns invoice with line items, amounts, taxes, payment status, and full audit trail.
    Use for customer service or billing inquiries.
  DESC

  input_schema(
    properties: {
      invoice_id: { type: 'integer', description: 'Unique Pike13 invoice ID' }
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
  description <<~DESC
    [STAFF] Get available payment methods for an invoice.
    Returns all payment methods that can be used to pay this invoice.
    Use when processing payment for a customer.
  DESC

  input_schema(
    properties: {
      invoice_id: { type: 'integer', description: 'Unique Pike13 invoice ID' }
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
  description <<~DESC
    [STAFF] Create a new invoice.
    Creates invoice for specified person with optional line items.
    Returns created invoice with ID.
    Use for manual billing or custom charges.
  DESC

  input_schema(
    properties: {
      person_id: { type: 'integer', description: 'Person ID for the invoice' },
      additional_attributes: { type: 'object', description: 'Optional: Additional invoice attributes as a hash (e.g., due_on, notes)' }
    },
    required: ['person_id']
  )

  class << self
    def call(person_id:, additional_attributes: nil, server_context:)
      attributes = { person_id: person_id }
      attributes.merge!(additional_attributes) if additional_attributes

      Pike13::Desk::Invoice.create(attributes).to_json
    end
  end
end

class DeskUpdateInvoice < Pike13BaseTool
  description <<~DESC
    [STAFF] Update an existing invoice.
    Updates invoice details like due date, notes, or status.
    Returns updated invoice.
    Use for corrections or administrative changes.
  DESC

  input_schema(
    properties: {
      invoice_id: { type: 'integer', description: 'Unique Pike13 invoice ID to update' },
      attributes: { type: 'object', description: 'Invoice attributes to update as a hash' }
    },
    required: ['invoice_id', 'attributes']
  )

  class << self
    def call(invoice_id:, attributes:, server_context:)
      Pike13::Desk::Invoice.update(invoice_id, attributes).to_json
    end
  end
end

class DeskCreateInvoiceItem < Pike13BaseTool
  description <<~DESC
    [STAFF] Add an item to an invoice.
    Creates a new line item on the invoice with description and amount.
    Returns updated invoice with new item.
    Use for adding charges, services, or products to invoice.
  DESC

  input_schema(
    properties: {
      invoice_id: { type: 'integer', description: 'Invoice ID to add item to' },
      description: { type: 'string', description: 'Item description' },
      amount_cents: { type: 'integer', description: 'Item amount in cents' },
      additional_attributes: { type: 'object', description: 'Optional: Additional item attributes (revenue_category_id, sales_tax_id, etc.)' }
    },
    required: ['invoice_id', 'description', 'amount_cents']
  )

  class << self
    def call(invoice_id:, description:, amount_cents:, additional_attributes: nil, server_context:)
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
  description <<~DESC
    [STAFF] Remove an item from an invoice.
    Deletes a line item from the invoice.
    Returns updated invoice.
    Use for removing incorrect charges or cancelled items.
  DESC

  input_schema(
    properties: {
      invoice_id: { type: 'integer', description: 'Invoice ID' },
      item_id: { type: 'integer', description: 'Invoice item ID to delete' }
    },
    required: ['invoice_id', 'item_id']
  )

  class << self
    def call(invoice_id:, item_id:, server_context:)
      Pike13::Desk::Invoice.destroy_invoice_item(invoice_id, item_id).to_json
    end
  end
end

class DeskCreateInvoiceItemDiscount < Pike13BaseTool
  description <<~DESC
    [STAFF] Add a discount to an invoice item.
    Creates discount on specific line item.
    Returns updated invoice with discount applied.
    Use for promotional discounts or adjustments.
  DESC

  input_schema(
    properties: {
      invoice_id: { type: 'integer', description: 'Invoice ID' },
      invoice_item_id: { type: 'integer', description: 'Invoice item ID to discount' },
      attributes: { type: 'object', description: 'Discount attributes (amount_cents or percentage)' }
    },
    required: ['invoice_id', 'invoice_item_id', 'attributes']
  )

  class << self
    def call(invoice_id:, invoice_item_id:, attributes:, server_context:)
      Pike13::Desk::Invoice.create_discount(invoice_id, invoice_item_id, attributes).to_json
    end
  end
end

class DeskGetInvoiceItemDiscounts < Pike13BaseTool
  description <<~DESC
    [STAFF] Get discounts for an invoice item.
    Returns all discounts applied to the invoice item.
    Use to review discount details.
  DESC

  input_schema(
    properties: {
      invoice_id: { type: 'integer', description: 'Invoice ID' },
      invoice_item_id: { type: 'integer', description: 'Invoice item ID' }
    },
    required: ['invoice_id', 'invoice_item_id']
  )

  class << self
    def call(invoice_id:, invoice_item_id:, server_context:)
      Pike13::Desk::Invoice.discounts(invoice_id, invoice_item_id).to_json
    end
  end
end

class DeskDeleteInvoiceItemDiscounts < Pike13BaseTool
  description <<~DESC
    [STAFF] Remove all discounts from an invoice item.
    Deletes all discounts on the specified line item.
    Returns updated invoice.
    Use for removing promotional discounts.
  DESC

  input_schema(
    properties: {
      invoice_id: { type: 'integer', description: 'Invoice ID' },
      invoice_item_id: { type: 'integer', description: 'Invoice item ID' }
    },
    required: ['invoice_id', 'invoice_item_id']
  )

  class << self
    def call(invoice_id:, invoice_item_id:, server_context:)
      Pike13::Desk::Invoice.destroy_discounts(invoice_id, invoice_item_id).to_json
    end
  end
end

class DeskCreateInvoiceItemProrate < Pike13BaseTool
  description <<~DESC
    [STAFF] Create a prorate adjustment for an invoice item.
    Adds prorated amount to invoice item (for partial periods).
    Returns updated invoice with prorate.
    Use for membership prorations or partial month billing.
  DESC

  input_schema(
    properties: {
      invoice_id: { type: 'integer', description: 'Invoice ID' },
      invoice_item_id: { type: 'integer', description: 'Invoice item ID to prorate' },
      attributes: { type: 'object', description: 'Prorate attributes' }
    },
    required: ['invoice_id', 'invoice_item_id', 'attributes']
  )

  class << self
    def call(invoice_id:, invoice_item_id:, attributes:, server_context:)
      Pike13::Desk::Invoice.create_prorate(invoice_id, invoice_item_id, attributes).to_json
    end
  end
end

class DeskDeleteInvoiceItemProrate < Pike13BaseTool
  description <<~DESC
    [STAFF] Remove prorate from an invoice item.
    Deletes prorate adjustment from the line item.
    Returns updated invoice.
  DESC

  input_schema(
    properties: {
      invoice_id: { type: 'integer', description: 'Invoice ID' },
      invoice_item_id: { type: 'integer', description: 'Invoice item ID' }
    },
    required: ['invoice_id', 'invoice_item_id']
  )

  class << self
    def call(invoice_id:, invoice_item_id:, server_context:)
      Pike13::Desk::Invoice.destroy_prorate(invoice_id, invoice_item_id).to_json
    end
  end
end

class DeskCreateInvoicePayment < Pike13BaseTool
  description <<~DESC
    [STAFF] Create a payment for an invoice.
    Processes payment for the invoice using specified payment method.
    Returns payment confirmation with transaction details.
    Use for processing customer payments at desk.
  DESC

  input_schema(
    properties: {
      invoice_id: { type: 'integer', description: 'Invoice ID to pay' },
      attributes: { type: 'object', description: 'Payment attributes (amount_cents, form_of_payment_id, payment_type, etc.)' }
    },
    required: ['invoice_id', 'attributes']
  )

  class << self
    def call(invoice_id:, attributes:, server_context:)
      Pike13::Desk::Invoice.create_payment(invoice_id, attributes).to_json
    end
  end
end

class DeskCreateInvoiceRefund < Pike13BaseTool
  description <<~DESC
    [STAFF] Create a refund for an invoice payment.
    Issues refund on a specific payment.
    Returns refund confirmation.
    Use for processing customer refunds.
  DESC

  input_schema(
    properties: {
      invoice_id: { type: 'integer', description: 'Invoice ID' },
      payment_id: { type: 'integer', description: 'Payment ID to refund' },
      attributes: { type: 'object', description: 'Refund attributes (amount_cents, reason, etc.)' }
    },
    required: ['invoice_id', 'payment_id', 'attributes']
  )

  class << self
    def call(invoice_id:, payment_id:, attributes:, server_context:)
      Pike13::Desk::Invoice.create_refund(invoice_id, payment_id, attributes).to_json
    end
  end
end
