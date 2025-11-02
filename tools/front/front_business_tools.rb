# frozen_string_literal: true

require_relative '../base_tool'

class FrontGetBusiness < Pike13BaseTool
  description <<~DESC
    Get business info for customers: name, hours, contact, timezone.
    Use for "business hours", "contact info", "location" questions.
    Returns basic info - for admin details use DeskGetBusiness.
  DESC

  class << self
    def call(server_context:)
      Pike13::Front::Business.find.to_json
    end
  end
end
