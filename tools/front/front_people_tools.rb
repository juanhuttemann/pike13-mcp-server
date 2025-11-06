# frozen_string_literal: true

require_relative '../base_tool'

class FrontGetMe < Pike13BaseTool
  description "Get current person"

  class << self
    def call(server_context:)
      Pike13::Front::Person.me.to_json
    end
  end
end
