# frozen_string_literal: true

require_relative '../base_tool'

class ReportingMonthlyBusinessMetrics < Pike13BaseTool
  description <<~DESC
    Query monthly business metrics for financial analysis and reporting.

    Provides comprehensive monthly business data including:
    - Revenue metrics (net paid amounts, payments, refunds)
    - Client metrics (new clients, member counts, client retention)
    - Enrollment metrics (completed enrollments, attendance patterns)
    - Event metrics (class counts, appointment counts)
    - Plan metrics (membership counts, plan starts/ends)

    Supports advanced querying with filtering, grouping, sorting, and pagination.
    Perfect for financial reporting, business analytics, and performance tracking.

    Common detail fields: month_start_date, net_paid_amount, net_paid_revenue_amount,
    new_client_count, member_count, completed_enrollment_count, event_occurrence_count

    Common summary fields (when grouping): total_net_paid_amount, total_new_client_count,
    avg_member_count, total_completed_enrollment_count

    Available groupings: business_id, business_name, currency_code, quarter_start_date, year_start_date
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
        description: 'Filter conditions as nested arrays. Example: ["btw", "month_start_date", "2024-01-01", "2024-12-31"]'
      },
      group: {
        type: 'string',
        description: 'Group by field (e.g., "year_start_date", "business_id", "currency_code")'
      },
      sort: {
        type: 'array',
        items: { type: 'string' },
        description: 'Sort fields with +/- suffix for direction. Example: ["month_start_date-"] for descending'
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
    def call(fields:, server_context:, filter: nil, group: nil, sort: nil, page: nil, total_count: false)
      query_params = { fields: fields }
      query_params[:filter] = filter if filter
      query_params[:group] = group if group
      query_params[:sort] = sort if sort
      query_params[:page] = page if page
      query_params[:total_count] = total_count if total_count

      result = Pike13::Reporting::MonthlyBusinessMetrics.query(**query_params)
      result.to_json
    end
  end
end
