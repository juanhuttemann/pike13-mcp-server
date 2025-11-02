# frozen_string_literal: true

require_relative '../base_tool'

class FrontGetBranding < Pike13BaseTool
  description <<~DESC
    Get business branding assets (no auth required).
    Returns logo URLs, brand colors, custom CSS, and theme settings.
    Use to customize UI to match business brand identity or display branded content in customer apps.
  DESC

  class << self
    def call(server_context:)
      Pike13::Front::Branding.find.to_json
    end
  end
end
