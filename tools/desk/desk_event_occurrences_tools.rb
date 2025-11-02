# frozen_string_literal: true

require_relative '../base_tool'

class DeskListEventOccurrences < Pike13BaseTool
  description <<~DESC
    List scheduled class instances with admin data for date range.
    Returns occurrences with attendance, registrations, revenue, instructor assignments, and status.
    Use for staff schedule view, attendance tracking, or reporting.
    Required for most schedule operations.
  DESC

  input_schema(
    properties: {
      from: { type: 'string', description: 'Start date in YYYY-MM-DD format (e.g., "2025-01-15' },
      to: { type: 'string', description: 'End date in YYYY-MM-DD format (e.g., "2025-01-22' }
    },
    required: %w[from to]
  )

  class << self
    def call(from:, to:, server_context:)
      Pike13::Desk::EventOccurrence.all(from: from, to: to).to_json
    end
  end
end

class DeskGetEventOccurrence < Pike13BaseTool
  description <<~DESC
    Get complete scheduled class instance by ID.
    Returns full occurrence data: roster, attendance, revenue, notes, instructor, location, and all admin details.
    Use for attendance management, roster viewing, or occurrence-specific reporting.
  DESC

  input_schema(
    properties: {
      occurrence_id: { type: 'integer', description: 'Unique Pike13 event occurrence ID (integer)' }
    },
    required: ['occurrence_id']
  )

  class << self
    def call(occurrence_id:, server_context:)
      Pike13::Desk::EventOccurrence.find(occurrence_id).to_json
    end
  end
end

class DeskGetEventOccurrencesSummary < Pike13BaseTool
  description <<~DESC
    Get event occurrences summary for date range with admin data.
    Returns aggregated summary of scheduled classes by day with attendance and revenue stats.
    Use for reporting, dashboard views, or schedule analysis.
  DESC

  input_schema(
    properties: {
      from: { type: 'string', description: 'Start date in YYYY-MM-DD format' },
      to: { type: 'string', description: 'End date in YYYY-MM-DD format' },
      additional_params: { type: 'object', description: 'Optional: Additional filter parameters' }
    },
    required: %w[from to]
  )

  class << self
    def call(from:, to:, server_context:, additional_params: nil)
      params = { from: from, to: to }
      params.merge!(additional_params) if additional_params

      Pike13::Desk::EventOccurrence.summary(**params).to_json
    end
  end
end

class DeskGetEventOccurrenceEnrollmentEligibilities < Pike13BaseTool
  description <<~DESC
    Check enrollment eligibility for specific people in an event occurrence.
    Returns eligibility status and restrictions for specified person IDs.
    Use before enrolling people to verify they can join the class.
  DESC

  input_schema(
    properties: {
      occurrence_id: { type: 'integer', description: 'Event occurrence ID to check eligibility for' },
      person_ids: { type: 'string', description: 'Optional: Comma-delimited person IDs to check' },
      additional_params: { type: 'object', description: 'Optional: Additional parameters' }
    },
    required: ['occurrence_id']
  )

  class << self
    def call(occurrence_id:, server_context:, person_ids: nil, additional_params: nil)
      params = additional_params || {}
      params[:person_ids] = person_ids if person_ids

      Pike13::Desk::EventOccurrence.enrollment_eligibilities(id: occurrence_id, **params).to_json
    end
  end
end
