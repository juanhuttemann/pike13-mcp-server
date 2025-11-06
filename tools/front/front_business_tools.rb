# frozen_string_literal: true

require_relative '../base_tool'

class FrontGetBusiness < Pike13BaseTool
  description "Get business info"

  class << self
    def call(server_context:)
      Pike13::Front::Business.find.to_json
    end
  end
end
