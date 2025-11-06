# frozen_string_literal: true

require_relative '../base_tool'

class DeskGetBusiness < Pike13BaseTool
  description "Get business"

  class << self
    def call(server_context:)
      Pike13::Desk::Business.find.to_json
    end
  end
end
