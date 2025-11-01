# frozen_string_literal: true

require_relative 'base_tool'

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

class FrontGetBusiness < Pike13BaseTool
  description <<~DESC
    [CLIENT] Get business info for customers: name, hours, contact, timezone.
    Use for "business hours", "contact info", "location" questions.
    Returns basic info - for admin details use DeskGetBusiness.
  DESC

  class << self
    def call(server_context:)
      Pike13::Front::Business.find.to_json
    end
  end
end

class FrontGetBranding < Pike13BaseTool
  description <<~DESC
    [CLIENT] Get business branding assets (no auth required).
    Returns logo URLs, brand colors, custom CSS, and theme settings.
    Use to customize UI to match business brand identity or display branded content in customer apps.
  DESC

  class << self
    def call(server_context:)
      Pike13::Front::Branding.find.to_json
    end
  end
end

class DeskGetBusiness < Pike13BaseTool
  description <<~DESC
    [STAFF] Get admin business details: settings, billing, features, configs.
    Use for admin dashboards, business configuration, staff management.
    Contains sensitive info - NOT for customer display.
  DESC

  class << self
    def call(server_context:)
      Pike13::Desk::Business.find.to_json
    end
  end
end

class DeskGetBusinessFranchisees < Pike13BaseTool
  description <<~DESC
    [STAFF] Get franchisee businesses.
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

class FrontGetBusinessFranchisees < Pike13BaseTool
  description <<~DESC
    [CLIENT] Get franchisee businesses visible to customers.
    Returns list of franchisee locations customers can view.
    Use to display multiple franchise locations to customers.
  DESC

  class << self
    def call(server_context:)
      Pike13::Front::Business.franchisees.to_json
    end
  end
end
