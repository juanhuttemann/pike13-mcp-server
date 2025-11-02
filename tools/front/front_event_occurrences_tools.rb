# frozen_string_literal: true

require_relative "../base_tool"

class FrontListEventOccurrences < Pike13BaseTool
  description <<~DESC
    [CLIENT] STEP 2: List ACTUAL scheduled classes/times (not templates).
    Returns: Monday 9am Yoga, Tuesday 6pm Pilates, etc.
    Use AFTER FrontListEvents to get specific times for booking.
    Workflow: FrontListEvents → FrontListEventOccurrences → FrontCreateVisit to book.
  DESC

  input_schema(
    properties: {
      from: { type: 'string', description: 'Start date in YYYY-MM-DD format (e.g., "2025-01-15' },
      to: { type: 'string', description: 'End date in YYYY-MM-DD format (e.g., "2025-01-22' }
    },
    required: ['from', 'to']
  )

  class << self
    def call(from:, to:, server_context:)
      Pike13::Front::EventOccurrence.all(from: from, to: to).to_json
    end
  end
end

class FrontGetEventOccurrence < Pike13BaseTool
  description <<~DESC
    [CLIENT] Get specific scheduled class instance by ID.
    Returns occurrence with exact time, instructor, location, capacity, spots remaining, and current registrations.
    Use to show class details before booking or to check availability.
  DESC

  input_schema(
    properties: {
      occurrence_id: { type: 'integer', description: 'Unique Pike13 event occurrence ID (integer)' }
    },
    required: ['occurrence_id']
  )

  class << self
    def call(occurrence_id:, server_context:)
      Pike13::Front::EventOccurrence.find(occurrence_id).to_json
    end
  end
end

class FrontGetEventOccurrencesSummary < Pike13BaseTool
  description <<~DESC
    [CLIENT] Get event occurrences summary for date range.
    Returns aggregated summary of scheduled classes by day.
    Use for calendar views or availability overviews for customers.
  DESC

  input_schema(
    properties: {
      from: { type: 'string', description: 'Start date in YYYY-MM-DD format' },
      to: { type: 'string', description: 'End date in YYYY-MM-DD format' },
      additional_params: { type: 'object', description: 'Optional: Additional filter parameters' }
    },
    required: ['from', 'to']
  )

  class << self
    def call(from:, to:, additional_params: nil, server_context:)
      params = { from: from, to: to }
      params.merge!(additional_params) if additional_params

      Pike13::Front::EventOccurrence.summary(**params).to_json
    end
  end
end

class FrontGetEventOccurrenceEnrollmentEligibilities < Pike13BaseTool
  description <<~DESC
    [CLIENT] Check enrollment eligibility for an event occurrence.
    Returns eligibility status and restrictions for authenticated customer and dependents.
    Use before booking to check if customer can enroll and display appropriate warnings.
  DESC

  input_schema(
    properties: {
      occurrence_id: { type: 'integer', description: 'Event occurrence ID to check eligibility for' },
      additional_params: { type: 'object', description: 'Optional: Additional parameters' }
    },
    required: ['occurrence_id']
  )

  class << self
    def call(occurrence_id:, additional_params: nil, server_context:)
      params = additional_params || {}
      Pike13::Front::EventOccurrence.enrollment_eligibilities(id: occurrence_id, **params).to_json
    end
  end
end
