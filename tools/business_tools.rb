# frozen_string_literal: true

require_relative 'base_tool'

class Pike13AccountListBusinesses < Pike13BaseTool
  description '[ACCOUNT] List businesses'

  def call
    client.account.businesses.all.to_json
  end
end

class Pike13FrontGetBusiness < Pike13BaseTool
  description '[CLIENT] Get business info'

  def call
    client.front.business.find.to_json
  end
end

class Pike13FrontGetBranding < Pike13BaseTool
  description '[CLIENT] Get branding'

  def call
    client.front.branding.find.to_json
  end
end

class Pike13DeskGetBusiness < Pike13BaseTool
  description '[STAFF] Get business info'

  def call
    client.desk.business.find.to_json
  end
end
