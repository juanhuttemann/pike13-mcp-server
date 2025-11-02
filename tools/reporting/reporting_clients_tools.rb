require_relative "../base_tool"

class ReportingClients < Pike13BaseTool
  description <<~DESC
    Query comprehensive client data for business analytics and customer insights.

    Provides detailed client information including:
    - Identity data (name, email, phone, address)
    - Membership status and plan details
    - Activity metrics (visits, attendance patterns)
    - Financial data (payments, account credit)
    - Client tenure and retention metrics
    - Demographics and status information

    Supports advanced querying with filtering, grouping, sorting, and pagination.
    Perfect for customer analysis, retention tracking, and targeted marketing.

    Common detail fields: person_id, full_name, email, phone, client_since_date,
    has_membership, completed_visits, net_paid_amount, tenure, person_state

    Common summary fields (when grouping): person_count, has_membership_count,
    total_completed_visits, total_net_paid_amount, avg_tenure

    Available groupings: tenure_group, person_state, source_name, age, home_location_name,
    client_since_date, has_membership, has_payment_on_file, is_schedulable, also_staff
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
        description: 'Filter conditions as nested arrays. Example: ["eq", "has_membership", true]'
      },
      group: {
        type: 'string',
        description: 'Group by field (e.g., "tenure_group", "person_state", "home_location_name")'
      },
      sort: {
        type: 'array',
        items: { type: 'string' },
        description: 'Sort fields with +/- suffix for direction. Example: ["completed_visits-"] for descending'
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

      result = Pike13::Reporting::Clients.query(**query_params)
      result.to_json
    end
  end
end