# frozen_string_literal: true

require_relative 'base_tool'

class FrontGetInvoice < Pike13BaseTool
  description '[CLIENT] Get customer invoice by ID. Returns invoice with line items, amounts, taxes, payment status, and due date. Use to show customers their bills or payment history. Only returns invoices for authenticated customer.'

  arguments do
    required(:invoice_id).filled(:integer).description('Unique Pike13 invoice ID (integer)')
  end

  def call(invoice_id:)
    Pike13::Front::Invoice.find(invoice_id).to_json
  end
end

class DeskListInvoices < Pike13BaseTool
  description '[STAFF] List ALL invoices - AVOID for searches. Returns huge dataset. Use ONLY for "all invoices", "financial report", "accounts receivable". For specific customer invoices, search person first then get their invoices.'

  def call
    Pike13::Desk::Invoice.all.to_json
  end
end
