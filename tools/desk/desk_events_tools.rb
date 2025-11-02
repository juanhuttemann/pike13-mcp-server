# frozen_string_literal: true

require_relative '../base_tool'

class DeskListEvents < Pike13BaseTool
  description <<~DESC
    List all recurring events with admin details.
    Returns event templates including pricing, capacity, staff assignments, visibility settings, and booking rules.
    Use for schedule management and event configuration.
    Note: Events are recurring templates, not specific instances.
  DESC

  class << self
    def call(server_context:)
      Pike13::Desk::Event.all.to_json
    end
  end
end

class DeskGetEvent < Pike13BaseTool
  description <<~DESC
    Get complete event details by ID.
    Returns full event template with pricing, capacity, prerequisites, staff, location, recurrence rules, and all admin settings.
    Use when managing event configuration or analyzing event setup.
  DESC

  input_schema(
    properties: {
      event_id: { type: 'integer', description: 'Unique Pike13 event ID (integer)' }
    },
    required: ['event_id']
  )

  class << self
    def call(event_id:, server_context:)
      Pike13::Desk::Event.find(event_id).to_json
    end
  end
end
