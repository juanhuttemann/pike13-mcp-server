# frozen_string_literal: true

require_relative '../base_tool'

class DeskGetBusinessFranchisees < Pike13BaseTool
  description "Get franchisee businesses"

  class << self
    def call(server_context:)
      Pike13::Desk::Business.franchisees.to_json
    end
  end
end
