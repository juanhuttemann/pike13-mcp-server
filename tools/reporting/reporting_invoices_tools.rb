require_relative "../base_tool"

class ReportingInvoices < Pike13BaseTool
  description <<~DESC
    Query invoice data for billing analysis and accounts receivable management.

    Provides comprehensive invoice information including:
    - Invoice details (ID, number, state, due dates)
    - Financial amounts (gross, expected, paid, outstanding)
    - Revenue and tax breakdowns
    - Discounts, coupons, and adjustments
    - Payment tracking (payments, refunds, failed transactions)
    - Payer information and billing details
    - Invoice aging and overdue analysis

    Supports advanced querying with filtering, grouping, sorting, and pagination.
    Perfect for accounts receivable, revenue analysis, and billing reconciliation.

    Common detail fields: invoice_id, invoice_number, invoice_state, expected_amount,
    outstanding_amount, invoice_due_date, invoice_payer_name, days_since_invoice_due

    Common summary fields (when grouping): invoice_count, total_expected_amount,
    total_outstanding_amount, total_net_paid_amount, created_by_client_count

    Available groupings: invoice_state, purchase_request_state, created_by_client,
    invoice_autobill, issued_date, issued_month_start_date, closed_date,
    closed_month_start_date, invoice_due_date, invoice_payer_id, invoice_payer_name,
    invoice_payer_home_location, business_id, business_name, sale_location_name,
    commission_recipient_name
  DESC

  input_schema(
    properties: {
      fields: {
        type: 'array',
        items: { type: 'string' },
        description: 'Fields to include in results. Use detail fields for non-grouped queries, summary fields for grouped queries.'
      },
      filter: {
        type: 'array',
        description: 'Filter conditions as nested arrays. Example: ["gt", "outstanding_amount", 0]'
      },
      group: {
        type: 'string',
        description: 'Group by field (e.g., "invoice_state", "issued_month_start_date", "invoice_payer_name")'
      },
      sort: {
        type: 'array',
        items: { type: 'string' },
        description: 'Sort fields with +/- suffix for direction. Example: ["invoice_due_date"] for ascending'
      },
      page: {
        type: 'object',
        properties: {
          limit: { type: 'integer', description: 'Number of results per page (max 1000)' },
          offset: { type: 'integer', description: 'Number of results to skip' }
        },
        description: 'Pagination settings'
      },
      total_count: {
        type: 'boolean',
        description: 'Include total count in response metadata'
      }
    },
    required: ['fields']
  )

  class << self
    def call(fields:, filter: nil, group: nil, sort: nil, page: nil, total_count: false, server_context:)
      query_params = { fields: fields }
      query_params[:filter] = filter if filter
      query_params[:group] = group if group
      query_params[:sort] = sort if sort
      query_params[:page] = page if page
      query_params[:total_count] = total_count if total_count

      result = Pike13::Reporting::Invoices.query(**query_params)
      result.to_json
    end
  end
end