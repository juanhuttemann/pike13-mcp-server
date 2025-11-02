# frozen_string_literal: true

require_relative '../base_tool'

class DeskGetBusiness < Pike13BaseTool
  description <<~DESC
    Get admin business details: settings, billing, features, configs.
    Use for admin dashboards, business configuration, staff management.
    Contains sensitive info - NOT for customer display.
  DESC

  class << self
    def call(server_context:)
      Pike13::Desk::Business.find.to_json
    end
  end
end
