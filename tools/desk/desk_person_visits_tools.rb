# frozen_string_literal: true

require_relative '../base_tool'

class DeskListPersonVisits < Pike13BaseTool
  description <<~DESC
    List all visits (attendance records) for a person.
    Returns array of visit objects with event details, check-in/out times, visit status, payment info, and credits used.
    Use for attendance history, billing verification, or customer activity tracking.
  DESC

  input_schema(
    properties: {
      person_id: { type: 'integer', description: 'Unique Pike13 person ID (integer)' }
    },
    required: ['person_id']
  )

  class << self
    def call(person_id:, server_context:)
      Pike13::Desk::PersonVisit.all(person_id: person_id).to_json
    end
  end
end
