# frozen_string_literal: true

require_relative '../base_tool'

class ReportingStaffMembers < Pike13BaseTool
  description <<~DESC
    Query comprehensive staff member data for workforce analysis and HR management.

    Provides detailed staff information including:
    - Personal details (ID, name, contact information, birthdate, age)
    - Address information (street, city, state, postal code, country)
    - Staff-specific data (role, state, visibility to clients, client status)
    - Tenure information (start date, tenure, tenure groups)
    - Event metrics (future and past event counts, attendance completion)
    - Custom field data
    - Demographics and employment status

    Supports advanced querying with filtering, grouping, sorting, and pagination.
    Perfect for workforce analysis, HR reporting, and staff performance tracking.

    Common detail fields: person_id, full_name, email, phone, role, person_state,
    show_to_clients, also_client, home_location_name, staff_since_date, tenure,
    future_events, past_events

    Common summary fields (when grouping): person_count, also_client_count,
    demoted_staff_count, total_future_events, total_past_events, total_attendance_not_completed_events

    Available groupings: role, person_state, show_to_clients, also_client,
    home_location_name, staff_since_date, staff_since_month_start_date,
    staff_since_quarter_start_date, staff_since_week_mon_start_date,
    staff_since_week_sun_start_date, staff_since_year_start_date, tenure_group, age,
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
        description: 'Filter conditions as nested arrays. Example: ["eq", "person_state", "active"]'
      },
      group: {
        type: 'string',
        description: 'Group by field (e.g., "role", "home_location_name", "tenure_group")'
      },
      sort: {
        type: 'array',
        items: { type: 'string' },
        description: 'Sort fields with +/- suffix for direction. Example: ["tenure-"] for descending'
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

      result = Pike13::Reporting::StaffMembers.query(**query_params)
      result.to_json
    end
  end
end
