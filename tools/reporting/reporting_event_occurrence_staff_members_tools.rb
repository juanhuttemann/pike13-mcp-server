# frozen_string_literal: true

require_relative '../base_tool'

class ReportingEventOccurrenceStaffMembers < Pike13BaseTool
  description <<~DESC
    Query event occurrence data by staff member for workload analysis and instructor performance.

    Provides detailed staff assignment information including:
    - Staff member details (ID, name, email, phone, role, location)
    - Event occurrence information (event name, service dates and times)
    - Capacity and enrollment metrics for each staff member
    - Attendance tracking by instructor (completed, registered, no-showed)
    - Service details (name, type, category, location)
    - Duration and workload metrics
    - Contact information and addresses

    Supports advanced querying with filtering, grouping, sorting, and pagination.
    Perfect for instructor scheduling, workload distribution, and performance analysis.

    Common detail fields: person_id, full_name, email, role, event_occurrence_id,
    event_name, service_date, service_time, enrollment_count, completed_enrollment_count,
    instructor_names, service_location_name

    Common summary fields (when grouping): person_count, event_occurrence_count,
    event_count, service_count, total_enrollment_count, total_completed_enrollment_count,
    total_duration_in_hours

    Available groupings: person_id, full_name, role, service_id, service_name,
    service_type, service_category, service_date, service_month_start_date,
    service_location_name, event_id, event_name, event_occurrence_id,
    service_week_mon_start_date, service_week_sun_start_date, attendance_completed,
    business_id, business_name
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
        description: 'Filter conditions as nested arrays. Example: ["eq", "person_id", 12345]'
      },
      group: {
        type: 'string',
        description: 'Group by field (e.g., "full_name", "role", "service_name")'
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
    def call(fields:, server_context:, filter: nil, group: nil, sort: nil, page: nil, total_count: false)
      query_params = { fields: fields }
      query_params[:filter] = filter if filter
      query_params[:group] = group if group
      query_params[:sort] = sort if sort
      query_params[:page] = page if page
      query_params[:total_count] = total_count if total_count

      result = Pike13::Reporting::EventOccurrenceStaffMembers.query(**query_params)
      result.to_json
    end
  end
end
