# frozen_string_literal: true

require_relative '../base_tool'

class ReportingEventOccurrences < Pike13BaseTool
  description "Query event data"

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
