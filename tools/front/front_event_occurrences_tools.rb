# frozen_string_literal: true

require_relative '../base_tool'

class FrontListEventOccurrences < Pike13BaseTool
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
      Pike13::Front::EventOccurrence.all(from: from, to: to).to_json
    end
  end
end

class FrontGetEventOccurrence < Pike13BaseTool
  description "Get event occurrence"

  input_schema(
    properties: {
      occurrence_id: { type: 'integer', description: 'Event occurrence ID' }
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
  description "Get event occurrences summary"

  input_schema(
    properties: {
      from: { type: 'string', description: 'Start date (YYYY-MM-DD)' },
      to: { type: 'string', description: 'End date (YYYY-MM-DD)' },
      additional_params: { type: 'object', description: 'Optional: Filters (location_ids, service_ids, staff_member_ids, group_by, state)' }
    },
    required: %w[from to]
  )

  class << self
    def call(from:, to:, server_context:, additional_params: nil)
      params = { from: from, to: to }
      params.merge!(additional_params) if additional_params

      Pike13::Front::EventOccurrence.summary(**params).to_json
    end
  end
end

class FrontGetEventOccurrenceEnrollmentEligibilities < Pike13BaseTool
  description "Get enrollment eligibilities"

  input_schema(
    properties: {
      occurrence_id: { type: 'integer', description: 'Event occurrence ID' },
      additional_params: { type: 'object', description: 'Optional: Additional parameters' }
    },
    required: ['occurrence_id']
  )

  class << self
    def call(occurrence_id:, server_context:, additional_params: nil)
      params = additional_params || {}
      Pike13::Front::EventOccurrence.enrollment_eligibilities(id: occurrence_id, **params).to_json
    end
  end
end
