# frozen_string_literal: true

require 'fast_mcp'
require_relative '../config/pike13_client'

# Base class for Pike13 tools
class Pike13BaseTool < FastMcp::Tool
  def initialize(*args, **kwargs)
    super
    configure_client
  end

  private

  def configure_client
    # Get credentials from Rack env headers
    env = Thread.current[:rack_env] || {}
    access_token = env['HTTP_X_PIKE13_ACCESS_TOKEN']
    base_url = env['HTTP_X_PIKE13_BASE_URL']

    configure_pike13(access_token: access_token, base_url: base_url)
  end
end
