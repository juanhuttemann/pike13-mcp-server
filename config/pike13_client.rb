# frozen_string_literal: true

require 'pike13'

# Pike13 client factory - creates client per request from headers
def pike13_client(access_token: nil, base_url: nil)
  Pike13::Client.new(
    access_token: access_token || ENV['PIKE13_ACCESS_TOKEN'],
    base_url: base_url || ENV['PIKE13_BASE_URL']
  )
end
