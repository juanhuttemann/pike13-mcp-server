# frozen_string_literal: true

require_relative 'base_tool'

class Pike13FrontListServices < Pike13BaseTool
  description '[CLIENT] List public service offerings. Returns services (classes, appointments, programs) with name, description, category, duration, and pricing. Use to display available services to customers for booking or browsing catalog.'

  def call
    client.front.services.all.to_json
  end
end

class Pike13DeskListServices < Pike13BaseTool
  description '[STAFF] List all services with admin details. Returns complete service catalog with pricing, duration, type (event/appointment), tax settings, revenue category, capacity rules, and visibility. Use for service configuration or schedule planning.'

  def call
    client.desk.services.all.to_json
  end
end
