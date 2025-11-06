# frozen_string_literal: true

require_relative '../base_tool'

class FrontListEvents < Pike13BaseTool
  description "List events"

  class << self
    def call(server_context:)
      Pike13::Front::Event.all.to_json
    end
  end
end

class FrontGetEvent < Pike13BaseTool
  description "Get event"

  input_schema(
    properties: {
      event_id: { type: 'integer', description: 'Event ID' }
    },
    required: ['event_id']
  )

  class << self
    def call(event_id:, server_context:)
      Pike13::Front::Event.find(event_id).to_json
    end
  end
end
