# frozen_string_literal: true

require_relative '../base_tool'

class DeskListLocations < Pike13BaseTool
  description <<~DESC
    [STAFF] List all business locations with admin details.
    Returns locations with full address, contact info, timezone, capacity, amenities, visibility settings, and operational status.
    Use for location management or staff scheduling.
  DESC

  class << self
    def call(server_context:)
      Pike13::Desk::Location.all.to_json
    end
  end
end

class DeskGetLocation < Pike13BaseTool
  description <<~DESC
    [STAFF] Get specific location by ID with full admin details.
    Returns complete location data including capacity, amenities, visibility settings, operational status, and configuration.
    Use for location management or administrative tasks.
  DESC

  input_schema(
    properties: {
      location_id: { type: 'integer', description: 'Unique Pike13 location ID' }
    },
    required: ['location_id']
  )

  class << self
    def call(location_id:, server_context:)
      Pike13::Desk::Location.find(location_id).to_json
    end
  end
end
