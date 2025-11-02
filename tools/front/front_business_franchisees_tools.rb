# frozen_string_literal: true

require_relative '../base_tool'

class FrontGetBusinessFranchisees < Pike13BaseTool
  description <<~DESC
    Get franchisee businesses visible to customers.
    Returns list of franchisee locations customers can view.
    Use to display multiple franchise locations to customers.
  DESC

  class << self
    def call(server_context:)
      Pike13::Front::Business.franchisees.to_json
    end
  end
end
