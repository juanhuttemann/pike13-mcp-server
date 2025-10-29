# frozen_string_literal: true

require 'pike13'

# Configure Pike13 globally per request using the provided credentials
def configure_pike13(access_token: nil, base_url: nil)
  Pike13.configure do |config|
    config.access_token = access_token || ENV['PIKE13_ACCESS_TOKEN']
    config.base_url = base_url || ENV['PIKE13_BASE_URL']
  end
end
