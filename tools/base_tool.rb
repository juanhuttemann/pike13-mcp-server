# frozen_string_literal: true

require 'mcp'
require_relative '../config/pike13_client'

# Module that wraps tool calls with Pike13 configuration and error handling
module Pike13ToolWrapper
  def call(**kwargs)
    server_context = kwargs[:server_context]

    # Configure Pike13 client from server_context
    access_token = server_context[:access_token]
    base_url = server_context[:base_url]
    configure_pike13(access_token: access_token, base_url: base_url)

    # Call the actual implementation
    result = super(**kwargs)

    # Wrap result in MCP::Tool::Response if it's not already
    return result if result.is_a?(MCP::Tool::Response)

    MCP::Tool::Response.new([{
      type: 'text',
      text: result
    }])
  rescue Pike13::ConfigurationError
    error_response('Configuration error: Pike13 access token or base URL is missing or invalid.')
  rescue Pike13::AuthenticationError
    error_response('Authentication failed: Invalid or expired access token.')
  rescue Pike13::RateLimitError => e
    reset_info = e.rate_limit_reset ? " Resets at #{e.rate_limit_reset}." : ''
    error_response("Rate limit exceeded.#{reset_info}")
  rescue Pike13::NotFoundError
    error_response('Resource not found. The ID may be incorrect or the resource was deleted.')
  rescue Pike13::ValidationError => e
    details = format_error_details(e.response_body)
    error_response("Validation error: #{details}")
  rescue Pike13::BadRequestError => e
    details = format_error_details(e.response_body)
    error_response("Bad request: #{details}")
  rescue Pike13::ServerError => e
    error_response("Pike13 server error (HTTP #{e.http_status}).")
  rescue Pike13::ConnectionError
    error_response('Connection failed: Cannot reach Pike13 API. Check network and base URL.')
  rescue Timeout::Error, Errno::ETIMEDOUT, Errno::ECONNREFUSED, SocketError
    error_response('Connection failed: Cannot reach Pike13 API. Check network and base URL.')
  rescue StandardError => e
    error_response("Error: #{e.message}")
  end

  private

  def error_response(message)
    MCP::Tool::Response.new([{
      type: 'text',
      text: message
    }])
  end

  def format_error_details(response_body)
    return response_body.to_s unless response_body.is_a?(Hash)

    response_body.map { |k, v| "#{k}: #{v}" }.join(', ')
  end
end

# Base class for Pike13 tools
class Pike13BaseTool < MCP::Tool
  # Automatically prepend the wrapper module to all subclasses
  def self.inherited(subclass)
    super
    subclass.singleton_class.prepend(Pike13ToolWrapper)
  end
end
