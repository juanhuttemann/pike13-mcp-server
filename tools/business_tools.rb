# frozen_string_literal: true

require_relative 'base_tool'

class AccountListBusinesses < Pike13BaseTool
  description '[ACCOUNT] List all Pike13 businesses accessible to the authenticated account. Returns array with business IDs, names, and URLs. Use this to discover which businesses the user can access before making business-specific API calls.'

  def call
    client.account.businesses.all.to_json
  end
end

class FrontGetBusiness < Pike13BaseTool
  description '[CLIENT] Get public business information visible to customers. Returns business name, description, contact details, timezone, and hours. Use for customer-facing features like displaying business info on booking pages.'

  def call
    client.front.business.find.to_json
  end
end

class FrontGetBranding < Pike13BaseTool
  description '[CLIENT] Get business branding assets (no auth required). Returns logo URLs, brand colors, custom CSS, and theme settings. Use to customize UI to match business brand identity or display branded content in customer apps.'

  def call
    client.front.branding.find.to_json
  end
end

class DeskGetBusiness < Pike13BaseTool
  description '[STAFF] Get comprehensive business information including admin settings. Returns full business details: contact, address, timezone, billing, enabled features, and configurations. Use for staff/admin dashboards requiring complete business context.'

  def call
    client.desk.business.find.to_json
  end
end
