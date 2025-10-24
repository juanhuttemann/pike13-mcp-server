# frozen_string_literal: true

require_relative 'base_tool'

class FrontGetInvoice < Pike13BaseTool
  description '[CLIENT] Get customer invoice by ID. Returns invoice with line items, amounts, taxes, payment status, and due date. Use to show customers their bills or payment history. Only returns invoices for authenticated customer.'

  arguments do
    required(:invoice_id).filled(:integer).description('Unique Pike13 invoice ID (integer)')
  end

  def call(invoice_id:)
    client.front.invoices.find(invoice_id).to_json
  end
end

class DeskListInvoices < Pike13BaseTool
  description '[STAFF] List all invoices across business. Returns invoices with customer, line items, totals, taxes, payment status, and dates. Use for financial reporting, accounts receivable, or payment tracking. May return large datasets.'

  def call
    client.desk.invoices.all.to_json
  end
end
