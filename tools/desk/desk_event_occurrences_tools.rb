# frozen_string_literal: true

require_relative '../base_tool'

class DeskListEventOccurrences < Pike13BaseTool
  description "List event occurrences"

  input_schema(
    properties: {
      from: { type: 'string', description: 'Start date (YYYY-MM-DD)' },
      to: { type: 'string', description: 'End date (YYYY-MM-DD)' }
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
  description "Get event occurrence"

  input_schema(
    properties: {
      occurrence_id: { type: 'integer', description: 'Event occurrence ID' }
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
  description "Get event occurrences summary"

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
  description "Check enrollment eligibility"

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
