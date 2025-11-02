require_relative "../base_tool"

class ReportingPersonPlans < Pike13BaseTool
  description <<~DESC
    Query person plan data for membership analysis and plan utilization tracking.

    Provides comprehensive person plan information including:
    - Plan details (ID, name, type, product information)
    - Person information (ID, name, contact details, home location)
    - Plan dates (start, end, last usable, first/last visit dates)
    - Plan status (available, on hold, canceled, exhausted, ended, deactivated)
    - Visit tracking (allowed, used, remaining, lifetime usage)
    - Membership information (grants membership, first membership/plan flags)
    - Billing details (base price, invoice intervals, commitment length)
    - Invoice information (latest due date, amount, past due status)
    - Hold information (start/end dates, who placed hold, indefinite status)
    - Next plan information (ID, name, type, start date)
    - Timing metrics (time to first visit, plan transitions)

    Supports advanced querying with filtering, grouping, sorting, and pagination.
    Perfect for membership analysis, plan retention tracking, and utilization reporting.

    Common detail fields: person_plan_id, plan_name, plan_type, full_name, is_available,
    is_on_hold, start_date, end_date, used_visit_count, remaining_visit_count,
    grants_membership, latest_invoice_due_date

    Common summary fields (when grouping): person_plan_count, person_count, plan_count,
    is_available_count, is_on_hold_count, is_canceled_count, grants_membership_count,
    total_used_visit_count, total_lifetime_used_visit_count

    Available groupings: plan_id, plan_name, plan_type, product_id, product_name,
    plan_location_name, person_id, full_name, home_location_name, primary_staff_name,
    is_available, is_on_hold, is_canceled, grants_membership, is_first_plan,
    start_date, start_month_start_date, first_visit_date, first_visit_month_start_date,
    last_visit_date, latest_invoice_past_due, latest_invoice_autobill, latest_invoice_due_date,
    business_id, business_name, business_subdomain, revenue_category
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
        description: 'Filter conditions as nested arrays. Example: ["and", [["eq", "is_available", true], ["eq", "grants_membership", true]]]'
      },
      group: {
        type: 'string',
        description: 'Group by field (e.g., "plan_name", "is_available", "plan_type")'
      },
      sort: {
        type: 'array',
        items: { type: 'string' },
        description: 'Sort fields with +/- suffix for direction. Example: ["start_date-"] for descending'
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

      result = Pike13::Reporting::PersonPlans.query(**query_params)
      result.to_json
    end
  end
end