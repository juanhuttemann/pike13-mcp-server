# frozen_string_literal: true

require_relative 'base_tool'

class Pike13FrontGetInvoice < Pike13BaseTool
  description '[CLIENT] Get invoice by ID'

  arguments do
    required(:invoice_id).filled(:integer).description('Invoice ID')
  end

  def call(invoice_id:)
    client.front.invoices.find(invoice_id).to_json
  end
end

class Pike13DeskListInvoices < Pike13BaseTool
  description '[STAFF] List all invoices'

  def call
    client.desk.invoices.all.to_json
  end
end
