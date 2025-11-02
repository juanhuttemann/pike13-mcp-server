require_relative "../base_tool"

class ReportingInvoiceItems < Pike13BaseTool
  description <<~DESC
    Query invoice item data for detailed revenue analysis and product sales tracking.

    Provides comprehensive invoice item information including:
    - Invoice item details (ID, invoice number, state)
    - Product information (name, type, membership grants)
    - Financial amounts (gross, expected, revenue, tax)
    - Discounts, coupons, and adjustments
    - Payment tracking (net paid, outstanding amounts)
    - Payer information and billing details
    - Tax information and categories
    - Commission and sales location data
    - Purchase order and request information

    Supports advanced querying with filtering, grouping, sorting, and pagination.
    Perfect for revenue analysis, product sales tracking, and detailed billing reports.

    Common detail fields: invoice_item_id, invoice_number, product_name, product_type,
    gross_amount, expected_amount, expected_revenue_amount, outstanding_amount,
    invoice_payer_name, discounts_amount, coupons_amount

    Common summary fields (when grouping): invoice_item_count, invoice_count,
    total_gross_amount, total_expected_amount, total_expected_revenue_amount,
    total_outstanding_amount, total_discounts_amount, total_coupons_amount

    Available groupings: product_id, product_name, product_name_at_sale, product_type,
    grants_membership, plan_id, invoice_id, invoice_number, invoice_state, invoice_autobill,
    invoice_due_date, invoice_payer_id, invoice_payer_name, invoice_payer_home_location,
    invoice_payer_primary_staff_name_at_sale, issued_date, issued_month_start_date,
    issued_quarter_start_date, issued_year_start_date, due_month_start_date,
    due_quarter_start_date, due_year_start_date, closed_date, closed_month_start_date,
    closed_quarter_start_date, closed_year_start_date, issued_week_mon_start_date,
    issued_week_sun_start_date, due_week_mon_start_date, due_week_sun_start_date,
    closed_week_mon_start_date, closed_week_sun_start_date, discount_type, coupon_code,
    revenue_category, sale_location_name, commission_recipient_name, created_by_client,
    created_by_name, purchase_request_state, business_id, business_name, business_subdomain
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
        description: 'Filter conditions as nested arrays. Example: ["gt", "discounts_amount", 0]'
      },
      group: {
        type: 'string',
        description: 'Group by field (e.g., "product_name", "product_type", "issued_month_start_date")'
      },
      sort: {
        type: 'array',
        items: { type: 'string' },
        description: 'Sort fields with +/- suffix for direction. Example: ["expected_amount-"] for descending'
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

      result = Pike13::Reporting::InvoiceItems.query(**query_params)
      result.to_json
    end
  end
end