# frozen_string_literal: true

require_relative '../base_tool'

class FrontGetBusinessFranchisees < Pike13BaseTool
  description "Get franchisee businesses"

  class << self
    def call(server_context:)
      Pike13::Front::Business.franchisees.to_json
    end
  end
end
