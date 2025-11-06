# frozen_string_literal: true

require_relative '../base_tool'

class FrontListLocations < Pike13BaseTool
  description "List locations"

  class << self
    def call(server_context:)
      Pike13::Front::Location.all.to_json
    end
  end
end

class FrontGetLocation < Pike13BaseTool
  description "Get location"

  input_schema(
    properties: {
      location_id: { type: 'integer', description: 'Location ID' }
    },
    required: ['location_id']
  )

  class << self
    def call(location_id:, server_context:)
      Pike13::Front::Location.find(location_id).to_json
    end
  end
end
