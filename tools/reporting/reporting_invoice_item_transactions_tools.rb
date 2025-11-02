require_relative "../base_tool"

class ReportingInvoiceItemTransactions < Pike13BaseTool
  description <<~DESC
    Query invoice item transaction data for detailed payment and refund tracking.

    Provides comprehensive transaction-level information including:
    - Transaction details (ID, type, state, dates)
    - Payment information (method, processing details, card types)
    - Financial amounts (net paid, revenue, tax, payments, refunds)
    - Invoice and invoice item associations
    - Payer information and billing details
    - Product information from invoice items
    - Failed transaction details and error messages
    - Refund tracking with original payment references
    - Processing method and external payment details

    Supports advanced querying with filtering, grouping, sorting, and pagination.
    Perfect for payment reconciliation, refund tracking, and detailed transaction analysis.

    Common detail fields: transaction_id, transaction_type, transaction_state,
    transaction_amount, net_paid_amount, payment_method, payment_method_detail,
    invoice_number, invoice_payer_name, product_name

    Common summary fields (when grouping): transaction_count, settled_count, failed_count,
    total_net_paid_amount, total_net_paid_revenue_amount, total_net_paid_tax_amount,
    total_payments_amount, total_refunds_amount

    Available groupings: transaction_id, transaction_type, transaction_state,
    transaction_autopay, transaction_date, transaction_month_start_date,
    transaction_quarter_start_date, transaction_year_start_date, transaction_week_mon_start_date,
    transaction_week_sun_start_date, failed_date, failed_month_start_date, failed_quarter_start_date,
    failed_year_start_date, failed_week_mon_start_date, failed_week_sun_start_date,
    payment_method, processing_method, credit_card_name, external_payment_name,
    invoice_id, invoice_number, invoice_state, invoice_autobill, invoice_due_date,
    invoice_item_id, invoice_payer_id, invoice_payer_name, invoice_payer_home_location,
    invoice_payer_primary_staff_name_at_sale, product_id, product_name, product_name_at_sale,
    product_type, grants_membership, plan_id, revenue_category, sale_location_name,
    commission_recipient_name, created_by_name, business_id, business_name, business_subdomain
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
        description: 'Filter conditions as nested arrays. Example: ["eq", "transaction_type", "payment"]'
      },
      group: {
        type: 'string',
        description: 'Group by field (e.g., "payment_method", "transaction_month_start_date", "credit_card_name")'
      },
      sort: {
        type: 'array',
        items: { type: 'string' },
        description: 'Sort fields with +/- suffix for direction. Example: ["transaction_date-"] for descending'
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

      result = Pike13::Reporting::InvoiceItemTransactions.query(**query_params)
      result.to_json
    end
  end
end