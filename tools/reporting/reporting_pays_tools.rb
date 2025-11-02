require_relative "../base_tool"

class ReportingPays < Pike13BaseTool
  description <<~DESC
    Query staff pay data for compensation analysis and payroll management.

    Provides comprehensive pay information including:
    - Pay details (ID, type, state, descriptions, periods)
    - Pay amounts (final, base, per-head, tiered)
    - Staff information (ID, name, home location)
    - Service details (name, type, category, date, location, hours)
    - Pay recording and review information
    - Revenue category associations

    Supports advanced querying with filtering, grouping, sorting, and pagination.
    Perfect for payroll analysis, compensation tracking, and staff cost management.

    Common detail fields: pay_id, pay_type, pay_state, final_pay_amount,
    base_pay_amount, staff_name, service_name, service_date, service_hours,
    pay_period_start_date, pay_period_end_date

    Common summary fields (when grouping): pay_count, service_count, total_count,
    total_final_pay_amount, total_base_pay_amount, total_per_head_pay_amount,
    total_tiered_pay_amount, total_service_hours

    Available groupings: pay_type, pay_state, pay_period, pay_reviewed_date,
    pay_reviewed_by_id, pay_reviewed_by_name, staff_id, staff_name,
    staff_home_location_name, service_id, service_name, service_type,
    service_category, service_date, service_location_name, revenue_category,
    business_id, business_name, business_subdomain
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
        description: 'Filter conditions as nested arrays. Example: ["eq", "pay_state", "pending"]'
      },
      group: {
        type: 'string',
        description: 'Group by field (e.g., "staff_name", "pay_type", "service_name")'
      },
      sort: {
        type: 'array',
        items: { type: 'string' },
        description: 'Sort fields with +/- suffix for direction. Example: ["service_date-"] for descending'
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

      result = Pike13::Reporting::Pays.query(**query_params)
      result.to_json
    end
  end
end