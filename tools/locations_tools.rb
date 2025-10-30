# frozen_string_literal: true

require_relative 'base_tool'

# Front (CLIENT) Location Tools

class FrontListLocations < Pike13BaseTool
  description <<~DESC
    [CLIENT] List public business locations.
    Returns locations with name, address, timezone, phone, and hours.
    Use to display location options to customers for booking or finding addresses.
    Shows only publicly visible locations.
  DESC

  def call
    Pike13::Front::Location.all.to_json
  end
end

class FrontGetLocation < Pike13BaseTool
  description <<~DESC
    [CLIENT] Get specific location by ID.
    Returns location details including address, hours, contact info, and timezone.
    Use to show detailed location information to customers.
  DESC

  arguments do
    required(:location_id).filled(:integer).description('Unique Pike13 location ID')
  end

  def call(location_id:)
    Pike13::Front::Location.find(location_id).to_json
  end
end

# Desk (STAFF) Location Tools

class DeskListLocations < Pike13BaseTool
  description <<~DESC
    [STAFF] List all business locations with admin details.
    Returns locations with full address, contact info, timezone, capacity, amenities, visibility settings, and operational status.
    Use for location management or staff scheduling.
  DESC

  def call
    Pike13::Desk::Location.all.to_json
  end
end

class DeskGetLocation < Pike13BaseTool
  description <<~DESC
    [STAFF] Get specific location by ID with full admin details.
    Returns complete location data including capacity, amenities, visibility settings, operational status, and configuration.
    Use for location management or administrative tasks.
  DESC

  arguments do
    required(:location_id).filled(:integer).description('Unique Pike13 location ID')
  end

  def call(location_id:)
    Pike13::Desk::Location.find(location_id).to_json
  end
end
