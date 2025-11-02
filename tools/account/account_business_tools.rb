# frozen_string_literal: true

require_relative '../base_tool'

class AccountListBusinesses < Pike13BaseTool
  description <<~DESC
    [ACCOUNT] List businesses user owns/administers. Returns: [{id, name, url}].
    Use ONLY when user asks "my businesses", "which businesses", "account businesses".
    NOT needed for regular operations - most users work within one business.
  DESC

  class << self
    def call(server_context:)
      Pike13::Account::Business.all.to_json
    end
  end
end
