# frozen_string_literal: true

require_relative 'base_tool'

# Front (CLIENT) Invoice Tools

class FrontListInvoices < Pike13BaseTool
  description <<~DESC
    [CLIENT] List customer invoices.
    Returns invoices for authenticated customer with line items, amounts, and payment status.
    Use to show customer their billing history.
  DESC

  def call
    Pike13::Front::Invoice.all.to_json
  end
end

class FrontGetInvoice < Pike13BaseTool
  description <<~DESC
    [CLIENT] Get customer invoice by ID.
    Returns invoice with line items, amounts, taxes, payment status, and due date.
    Use to show customers their bills or payment history.
    Only returns invoices for authenticated customer.
  DESC

  arguments do
    required(:invoice_id).filled(:integer).description('Unique Pike13 invoice ID (integer)')
  end

  def call(invoice_id:)
    Pike13::Front::Invoice.find(invoice_id).to_json
  end
end

class FrontGetInvoicePaymentMethods < Pike13BaseTool
  description <<~DESC
    [CLIENT] Get available payment methods for an invoice.
    Returns payment methods that can be used to pay this invoice.
    Use when customer is ready to pay an invoice.
  DESC

  arguments do
    required(:invoice_id).filled(:integer).description('Unique Pike13 invoice ID')
  end

  def call(invoice_id:)
    Pike13::Front::Invoice.payment_methods(invoice_id).to_json
  end
end

class FrontCreateInvoice < Pike13BaseTool
  description <<~DESC
    [CLIENT] Create a new invoice.
    Creates invoice for authenticated customer.
    Returns created invoice with ID.
  DESC

  arguments do
    required(:person_id).filled(:integer).description('Person ID for the invoice')
    optional(:additional_attributes).maybe(:hash).description('Optional: Additional invoice attributes as a hash')
  end

  def call(person_id:, additional_attributes: nil)
    attributes = { person_id: person_id }
    attributes.merge!(additional_attributes) if additional_attributes

    Pike13::Front::Invoice.create(attributes).to_json
  end
end

class FrontUpdateInvoice < Pike13BaseTool
  description <<~DESC
    [CLIENT] Update an existing invoice.
    Updates invoice details like due date or notes.
    Returns updated invoice.
  DESC

  arguments do
    required(:invoice_id).filled(:integer).description('Unique Pike13 invoice ID to update')
    required(:attributes).filled(:hash).description('Invoice attributes to update as a hash')
  end

  def call(invoice_id:, attributes:)
    Pike13::Front::Invoice.update(invoice_id, attributes).to_json
  end
end

class FrontCreateInvoiceItem < Pike13BaseTool
  description <<~DESC
    [CLIENT] Add an item to an invoice.
    Creates a new line item on the invoice.
    Returns updated invoice with new item.
  DESC

  arguments do
    required(:invoice_id).filled(:integer).description('Invoice ID to add item to')
    required(:description).filled(:string).description('Item description')
    required(:amount_cents).filled(:integer).description('Item amount in cents')
    optional(:additional_attributes).maybe(:hash).description('Optional: Additional item attributes')
  end

  def call(invoice_id:, description:, amount_cents:, additional_attributes: nil)
    attributes = {
      description: description,
      amount_cents: amount_cents
    }
    attributes.merge!(additional_attributes) if additional_attributes

    Pike13::Front::Invoice.create_invoice_item(invoice_id, attributes).to_json
  end
end

class FrontDeleteInvoiceItem < Pike13BaseTool
  description <<~DESC
    [CLIENT] Remove an item from an invoice.
    Deletes a line item from the invoice.
    Returns updated invoice.
  DESC

  arguments do
    required(:invoice_id).filled(:integer).description('Invoice ID')
    required(:item_id).filled(:integer).description('Invoice item ID to delete')
  end

  def call(invoice_id:, item_id:)
    Pike13::Front::Invoice.destroy_invoice_item(invoice_id, item_id).to_json
  end
end

class FrontCreateInvoicePayment < Pike13BaseTool
  description <<~DESC
    [CLIENT] Create a payment for an invoice.
    Processes payment for the invoice using specified payment method.
    Returns payment confirmation.
  DESC

  arguments do
    required(:invoice_id).filled(:integer).description('Invoice ID to pay')
    required(:attributes).filled(:hash).description('Payment attributes (amount_cents, form_of_payment_id, etc.)')
  end

  def call(invoice_id:, attributes:)
    Pike13::Front::Invoice.create_payment(invoice_id, attributes).to_json
  end
end

class FrontDeleteInvoicePayment < Pike13BaseTool
  description <<~DESC
    [CLIENT] Delete a payment from an invoice.
    Removes a payment from the invoice (if allowed).
    Returns updated invoice.
  DESC

  arguments do
    required(:invoice_id).filled(:integer).description('Invoice ID')
    required(:payment_id).filled(:integer).description('Payment ID to delete')
  end

  def call(invoice_id:, payment_id:)
    Pike13::Front::Invoice.destroy_payment(invoice_id, payment_id).to_json
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

  def call
    Pike13::Desk::Invoice.all.to_json
  end
end

class DeskGetInvoice < Pike13BaseTool
  description <<~DESC
    [STAFF] Get invoice by ID with full admin details.
    Returns invoice with line items, amounts, taxes, payment status, and full audit trail.
    Use for customer service or billing inquiries.
  DESC

  arguments do
    required(:invoice_id).filled(:integer).description('Unique Pike13 invoice ID')
  end

  def call(invoice_id:)
    Pike13::Desk::Invoice.find(invoice_id).to_json
  end
end

class DeskGetInvoicePaymentMethods < Pike13BaseTool
  description <<~DESC
    [STAFF] Get available payment methods for an invoice.
    Returns all payment methods that can be used to pay this invoice.
    Use when processing payment for a customer.
  DESC

  arguments do
    required(:invoice_id).filled(:integer).description('Unique Pike13 invoice ID')
  end

  def call(invoice_id:)
    Pike13::Desk::Invoice.payment_methods(invoice_id).to_json
  end
end

class DeskCreateInvoice < Pike13BaseTool
  description <<~DESC
    [STAFF] Create a new invoice.
    Creates invoice for specified person with optional line items.
    Returns created invoice with ID.
    Use for manual billing or custom charges.
  DESC

  arguments do
    required(:person_id).filled(:integer).description('Person ID for the invoice')
    optional(:additional_attributes).maybe(:hash).description('Optional: Additional invoice attributes as a hash (e.g., due_on, notes)')
  end

  def call(person_id:, additional_attributes: nil)
    attributes = { person_id: person_id }
    attributes.merge!(additional_attributes) if additional_attributes

    Pike13::Desk::Invoice.create(attributes).to_json
  end
end

class DeskUpdateInvoice < Pike13BaseTool
  description <<~DESC
    [STAFF] Update an existing invoice.
    Updates invoice details like due date, notes, or status.
    Returns updated invoice.
    Use for corrections or administrative changes.
  DESC

  arguments do
    required(:invoice_id).filled(:integer).description('Unique Pike13 invoice ID to update')
    required(:attributes).filled(:hash).description('Invoice attributes to update as a hash')
  end

  def call(invoice_id:, attributes:)
    Pike13::Desk::Invoice.update(invoice_id, attributes).to_json
  end
end

class DeskCreateInvoiceItem < Pike13BaseTool
  description <<~DESC
    [STAFF] Add an item to an invoice.
    Creates a new line item on the invoice with description and amount.
    Returns updated invoice with new item.
    Use for adding charges, services, or products to invoice.
  DESC

  arguments do
    required(:invoice_id).filled(:integer).description('Invoice ID to add item to')
    required(:description).filled(:string).description('Item description')
    required(:amount_cents).filled(:integer).description('Item amount in cents')
    optional(:additional_attributes).maybe(:hash).description('Optional: Additional item attributes (revenue_category_id, sales_tax_id, etc.)')
  end

  def call(invoice_id:, description:, amount_cents:, additional_attributes: nil)
    attributes = {
      description: description,
      amount_cents: amount_cents
    }
    attributes.merge!(additional_attributes) if additional_attributes

    Pike13::Desk::Invoice.create_invoice_item(invoice_id, attributes).to_json
  end
end

class DeskDeleteInvoiceItem < Pike13BaseTool
  description <<~DESC
    [STAFF] Remove an item from an invoice.
    Deletes a line item from the invoice.
    Returns updated invoice.
    Use for removing incorrect charges or cancelled items.
  DESC

  arguments do
    required(:invoice_id).filled(:integer).description('Invoice ID')
    required(:item_id).filled(:integer).description('Invoice item ID to delete')
  end

  def call(invoice_id:, item_id:)
    Pike13::Desk::Invoice.destroy_invoice_item(invoice_id, item_id).to_json
  end
end

class DeskCreateInvoiceItemDiscount < Pike13BaseTool
  description <<~DESC
    [STAFF] Add a discount to an invoice item.
    Creates discount on specific line item.
    Returns updated invoice with discount applied.
    Use for promotional discounts or adjustments.
  DESC

  arguments do
    required(:invoice_id).filled(:integer).description('Invoice ID')
    required(:invoice_item_id).filled(:integer).description('Invoice item ID to discount')
    required(:attributes).filled(:hash).description('Discount attributes (amount_cents or percentage)')
  end

  def call(invoice_id:, invoice_item_id:, attributes:)
    Pike13::Desk::Invoice.create_discount(invoice_id, invoice_item_id, attributes).to_json
  end
end

class DeskGetInvoiceItemDiscounts < Pike13BaseTool
  description <<~DESC
    [STAFF] Get discounts for an invoice item.
    Returns all discounts applied to the invoice item.
    Use to review discount details.
  DESC

  arguments do
    required(:invoice_id).filled(:integer).description('Invoice ID')
    required(:invoice_item_id).filled(:integer).description('Invoice item ID')
  end

  def call(invoice_id:, invoice_item_id:)
    Pike13::Desk::Invoice.discounts(invoice_id, invoice_item_id).to_json
  end
end

class DeskDeleteInvoiceItemDiscounts < Pike13BaseTool
  description <<~DESC
    [STAFF] Remove all discounts from an invoice item.
    Deletes all discounts on the specified line item.
    Returns updated invoice.
    Use for removing promotional discounts.
  DESC

  arguments do
    required(:invoice_id).filled(:integer).description('Invoice ID')
    required(:invoice_item_id).filled(:integer).description('Invoice item ID')
  end

  def call(invoice_id:, invoice_item_id:)
    Pike13::Desk::Invoice.destroy_discounts(invoice_id, invoice_item_id).to_json
  end
end

class DeskCreateInvoiceItemProrate < Pike13BaseTool
  description <<~DESC
    [STAFF] Create a prorate adjustment for an invoice item.
    Adds prorated amount to invoice item (for partial periods).
    Returns updated invoice with prorate.
    Use for membership prorations or partial month billing.
  DESC

  arguments do
    required(:invoice_id).filled(:integer).description('Invoice ID')
    required(:invoice_item_id).filled(:integer).description('Invoice item ID to prorate')
    required(:attributes).filled(:hash).description('Prorate attributes')
  end

  def call(invoice_id:, invoice_item_id:, attributes:)
    Pike13::Desk::Invoice.create_prorate(invoice_id, invoice_item_id, attributes).to_json
  end
end

class DeskDeleteInvoiceItemProrate < Pike13BaseTool
  description <<~DESC
    [STAFF] Remove prorate from an invoice item.
    Deletes prorate adjustment from the line item.
    Returns updated invoice.
  DESC

  arguments do
    required(:invoice_id).filled(:integer).description('Invoice ID')
    required(:invoice_item_id).filled(:integer).description('Invoice item ID')
  end

  def call(invoice_id:, invoice_item_id:)
    Pike13::Desk::Invoice.destroy_prorate(invoice_id, invoice_item_id).to_json
  end
end

class DeskCreateInvoicePayment < Pike13BaseTool
  description <<~DESC
    [STAFF] Create a payment for an invoice.
    Processes payment for the invoice using specified payment method.
    Returns payment confirmation with transaction details.
    Use for processing customer payments at desk.
  DESC

  arguments do
    required(:invoice_id).filled(:integer).description('Invoice ID to pay')
    required(:attributes).filled(:hash).description('Payment attributes (amount_cents, form_of_payment_id, payment_type, etc.)')
  end

  def call(invoice_id:, attributes:)
    Pike13::Desk::Invoice.create_payment(invoice_id, attributes).to_json
  end
end

class DeskCreateInvoiceRefund < Pike13BaseTool
  description <<~DESC
    [STAFF] Create a refund for an invoice payment.
    Issues refund on a specific payment.
    Returns refund confirmation.
    Use for processing customer refunds.
  DESC

  arguments do
    required(:invoice_id).filled(:integer).description('Invoice ID')
    required(:payment_id).filled(:integer).description('Payment ID to refund')
    required(:attributes).filled(:hash).description('Refund attributes (amount_cents, reason, etc.)')
  end

  def call(invoice_id:, payment_id:, attributes:)
    Pike13::Desk::Invoice.create_refund(invoice_id, payment_id, attributes).to_json
  end
end
