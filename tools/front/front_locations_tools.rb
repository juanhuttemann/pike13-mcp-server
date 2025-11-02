# frozen_string_literal: true

require_relative "../base_tool"

class FrontListLocations < Pike13BaseTool
  description <<~DESC
    [CLIENT] List public business locations.
    Returns locations with name, address, timezone, phone, and hours.
    Use to display location options to customers for booking or finding addresses.
    Shows only publicly visible locations.
  DESC

  class << self
    def call(server_context:)
      Pike13::Front::Location.all.to_json
    end
  end
end

class FrontGetLocation < Pike13BaseTool
  description <<~DESC
    [CLIENT] Get specific location by ID.
    Returns location details including address, hours, contact info, and timezone.
    Use to show detailed location information to customers.
  DESC

  input_schema(
    properties: {
      location_id: { type: 'integer', description: 'Unique Pike13 location ID' }
    },
    required: ['location_id']
  )

  class << self
    def call(location_id:, server_context:)
      Pike13::Front::Location.find(location_id).to_json
    end
  end
end
