# frozen_string_literal: true

require_relative '../base_tool'

class FrontGetMe < Pike13BaseTool
  description <<~DESC
    Get current customer profile details.
    Returns: name, email, phone, emergency contacts, profile photo, active memberships.
    Use ONLY when user asks "who am I", "my profile", "my info" or wants to view/edit their personal details.
    NOT needed for booking, viewing services, or regular customer operations.
  DESC

  class << self
    def call(server_context:)
      Pike13::Front::Person.me.to_json
    end
  end
end
