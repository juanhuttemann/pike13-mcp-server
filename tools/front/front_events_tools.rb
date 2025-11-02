# frozen_string_literal: true

require_relative '../base_tool'

class FrontListEvents < Pike13BaseTool
  description <<~DESC
    [CLIENT] STEP 1: List class/event TEMPLATES (not scheduled times).
    Returns: yoga class template, personal training template, etc.
    Use to show what types are available, then use FrontListEventOccurrences to get actual scheduled times for booking.
  DESC

  class << self
    def call(server_context:)
      Pike13::Front::Event.all.to_json
    end
  end
end

class FrontGetEvent < Pike13BaseTool
  description <<~DESC
    [CLIENT] Get public event details by ID.
    Returns event template with description, service, duration, instructor, location, capacity, and recurrence rules.
    Use to display class details before showing available times (event_occurrences).
  DESC

  input_schema(
    properties: {
      event_id: { type: 'integer', description: 'Unique Pike13 event ID (integer)' }
    },
    required: ['event_id']
  )

  class << self
    def call(event_id:, server_context:)
      Pike13::Front::Event.find(event_id).to_json
    end
  end
end
