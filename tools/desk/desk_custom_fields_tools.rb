# frozen_string_literal: true

require_relative '../base_tool'

class DeskListCustomFields < Pike13BaseTool
  description "List custom fields"

  class << self
    def call(server_context:)
      Pike13::Desk::CustomField.all.to_json
    end
  end
end
