# frozen_string_literal: true

require_relative '../base_tool'

class FrontGetBranding < Pike13BaseTool
  description "Get branding assets"

  class << self
    def call(server_context:)
      Pike13::Front::Branding.find.to_json
    end
  end
end
