# frozen_string_literal: true

require_relative '../base_tool'

class ReportingEventOccurrences < Pike13BaseTool
  description <<~DESC
    Query scheduled event occurrence data for capacity analysis and scheduling optimization.

    Provides comprehensive event occurrence information including:
    - Event details (occurrence ID, event name, service dates and times)
    - Capacity and enrollment metrics (capacity, enrollment count, waitlist)
    - Attendance tracking (completed, registered, no-showed enrollments)
    - Service information (name, type, category, location)
    - Instructor assignments and staff information
    - Payment status and billing details
    - Duration and timing information

    Supports advanced querying with filtering, grouping, sorting, and pagination.
    Perfect for capacity planning, attendance analysis, and scheduling optimization.

    Common detail fields: event_occurrence_id, event_name, service_date, service_time,
    enrollment_count, capacity, completed_enrollment_count, instructor_names, service_location_name

    Common summary fields (when grouping): event_occurrence_count, event_count, service_count,
    total_capacity, total_enrollment_count, total_completed_enrollment_count, total_noshowed_enrollment_count

    Available groupings: event_id, event_name, event_occurrence_id, instructor_names,
    service_id, service_name, service_type, service_category, service_location_name,
    service_state, service_date, service_day, service_time, service_month_start_date,
    service_quarter_start_date, service_year_start_date, service_week_mon_start_date,
    service_week_sun_start_date, attendance_completed, business_id, business_name
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
        description: 'Filter conditions as nested arrays. Example: ["gt", "completed_enrollment_count", 15]'
      },
      group: {
        type: 'string',
        description: 'Group by field (e.g., "service_name", "instructor_names", "service_date")'
      },
      sort: {
        type: 'array',
        items: { type: 'string' },
        description: 'Sort fields with +/- suffix for direction. Example: ["enrollment_count-"] for descending'
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

      result = Pike13::Reporting::EventOccurrences.query(**query_params)
      result.to_json
    end
  end
end
