# frozen_string_literal: true

require_relative '../base_tool'

class DeskGetBusinessFranchisees < Pike13BaseTool
  description <<~DESC
    Get franchisee businesses.
    Returns list of franchisee businesses associated with this franchisor account.
    Use for multi-location franchise management or reporting.
    Only works for franchisor accounts.
  DESC

  class << self
    def call(server_context:)
      Pike13::Desk::Business.franchisees.to_json
    end
  end
end
