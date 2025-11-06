# frozen_string_literal: true

require_relative '../base_tool'

class DeskListEvents < Pike13BaseTool
  description "List events"

  class << self
    def call(server_context:)
      Pike13::Desk::Event.all.to_json
    end
  end
end

class DeskGetEvent < Pike13BaseTool
  description "Get event"

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
