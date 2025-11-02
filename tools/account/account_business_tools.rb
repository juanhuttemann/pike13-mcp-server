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

class AccountGetBusiness < Pike13BaseTool
  description <<~DESC
    [ACCOUNT] Get specific business details by ID.
    Returns business object with name, subdomain, timezone, settings.
    Use when user needs details about a specific business they own or administer.
  DESC

  input_schema(
    properties: {
      business_id: { type: 'integer', description: 'Unique Pike13 business ID' }
    },
    required: ['business_id']
  )

  class << self
    def call(business_id:, server_context:)
      Pike13::Account::Business.find(business_id).to_json
    end
  end
end
