# frozen_string_literal: true

require_relative '../base_tool'

class ReportingEnrollments < Pike13BaseTool
  description <<~DESC
    Query enrollment and visit data for attendance analysis and service utilization.

    Provides comprehensive enrollment information including:
    - Visit details (ID, state, service dates and times)
    - Person information (name, contact details, birthdate)
    - Service information (name, type, category, location)
    - Event details (event name, occurrence ID, instructor names)
    - Payment status and billing information
    - Attendance tracking (first visits, no-shows, cancellations)
    - Booking patterns and client behavior
    - Waitlist and make-up information

    Supports advanced querying with filtering, grouping, sorting, and pagination.
    Perfect for attendance tracking, service utilization analysis, and booking analytics.

    Common detail fields: visit_id, full_name, service_name, state, service_date,
    service_time, instructor_names, is_paid, estimated_amount, first_visit

    Common summary fields (when grouping): enrollment_count, visit_count, person_count,
    completed_enrollment_count, noshowed_enrollment_count, total_visits_amount

    Available groupings: service_id, service_name, service_type, service_category,
    service_location_name, service_date, service_month_start_date, service_day,
    service_time, event_id, event_name, event_occurrence_id, instructor_names,
    person_id, full_name, home_location_name, primary_staff_name, paid_with,
    paid_with_type, plan_id, punch_id, is_paid, state, first_visit, client_booked,
    is_waitlist, consider_member, business_id, business_name
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
        description: 'Filter conditions as nested arrays. Example: ["eq", "state", "completed"]'
      },
      group: {
        type: 'string',
        description: 'Group by field (e.g., "service_name", "service_date", "instructor_names")'
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

      result = Pike13::Reporting::Enrollments.query(**query_params)
      result.to_json
    end
  end
end
