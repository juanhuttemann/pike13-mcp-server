# frozen_string_literal: true

require_relative '../base_tool'

class AccountListBusinesses < Pike13BaseTool
  description "List current user's businesses"

  class << self
    def call(server_context:)
      Pike13::Account::Business.all.to_json
    end
  end
end
