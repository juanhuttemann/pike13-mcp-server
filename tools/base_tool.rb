# frozen_string_literal: true

require 'fast_mcp'
require_relative '../config/pike13_client'

# Base class for Pike13 tools
class Pike13BaseTool < FastMcp::Tool
  def initialize(*args, **kwargs)
    super
    configure_client
  end

  # Override call_with_schema_validation! to add error handling
  def call_with_schema_validation!(**kwargs)
    super
  rescue Pike13::ConfigurationError => e
    "Configuration error: Pike13 access token or base URL is missing or invalid."
  rescue Pike13::AuthenticationError => e
    "Authentication failed: Invalid or expired access token."
  rescue Pike13::RateLimitError => e
    reset_info = e.rate_limit_reset ? " Resets at #{e.rate_limit_reset}." : ""
    "Rate limit exceeded.#{reset_info}"
  rescue Pike13::NotFoundError => e
    "Resource not found. The ID may be incorrect or the resource was deleted."
  rescue Pike13::ValidationError => e
    details = format_error_details(e.response_body)
    "Validation error: #{details}"
  rescue Pike13::BadRequestError => e
    details = format_error_details(e.response_body)
    "Bad request: #{details}"
  rescue Pike13::ServerError => e
    "Pike13 server error (HTTP #{e.http_status})."
  rescue Pike13::ConnectionError => e
    "Connection failed: Cannot reach Pike13 API. Check network and base URL."
  rescue Timeout::Error, Errno::ETIMEDOUT, Errno::ECONNREFUSED, SocketError => e
    "Connection failed: Cannot reach Pike13 API. Check network and base URL."
  rescue StandardError => e
    "Error: #{e.message}"
  end

  private

  def configure_client
    # Get credentials from Rack env headers
    env = Thread.current[:rack_env] || {}
    access_token = env['HTTP_X_PIKE13_ACCESS_TOKEN']
    base_url = env['HTTP_X_PIKE13_BASE_URL']

    configure_pike13(access_token: access_token, base_url: base_url)
  end

  def format_error_details(response_body)
    return response_body.to_s unless response_body.is_a?(Hash)
    response_body.map { |k, v| "#{k}: #{v}" }.join(", ")
  end
end
