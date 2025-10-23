# frozen_string_literal: true

require_relative 'base_tool'

class Pike13FrontListLocations < Pike13BaseTool
  description '[CLIENT] List public business locations. Returns locations with name, address, timezone, phone, and hours. Use to display location options to customers for booking or finding addresses. Shows only publicly visible locations.'

  def call
    client.front.locations.all.to_json
  end
end

class Pike13DeskListLocations < Pike13BaseTool
  description '[STAFF] List all business locations with admin details. Returns locations with full address, contact info, timezone, capacity, amenities, visibility settings, and operational status. Use for location management or staff scheduling.'

  def call
    client.desk.locations.all.to_json
  end
end
