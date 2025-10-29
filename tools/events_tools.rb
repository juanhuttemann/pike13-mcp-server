# frozen_string_literal: true

require_relative 'base_tool'

class FrontListEvents < Pike13BaseTool
  description '[CLIENT] STEP 1: List class/event TEMPLATES (not scheduled times). Returns: yoga class template, personal training template, etc. Use to show what types are available, then use FrontListEventOccurrences to get actual scheduled times for booking.'

  def call
    Pike13::Front::Event.all.to_json
  end
end

class FrontGetEvent < Pike13BaseTool
  description '[CLIENT] Get public event details by ID. Returns event template with description, service, duration, instructor, location, capacity, and recurrence rules. Use to display class details before showing available times (event_occurrences).'

  arguments do
    required(:event_id).filled(:integer).description('Unique Pike13 event ID (integer)')
  end

  def call(event_id:)
    Pike13::Front::Event.find(event_id).to_json
  end
end

class DeskListEvents < Pike13BaseTool
  description '[STAFF] List all recurring events with admin details. Returns event templates including pricing, capacity, staff assignments, visibility settings, and booking rules. Use for schedule management and event configuration. Note: Events are recurring templates, not specific instances.'

  def call
    Pike13::Desk::Event.all.to_json
  end
end

class DeskGetEvent < Pike13BaseTool
  description '[STAFF] Get complete event details by ID. Returns full event template with pricing, capacity, prerequisites, staff, location, recurrence rules, and all admin settings. Use when managing event configuration or analyzing event setup.'

  arguments do
    required(:event_id).filled(:integer).description('Unique Pike13 event ID (integer)')
  end

  def call(event_id:)
    Pike13::Desk::Event.find(event_id).to_json
  end
end
