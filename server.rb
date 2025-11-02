#!/usr/bin/env ruby
# frozen_string_literal: true

require 'bundler/setup'
Bundler.require(:default)
require 'mcp'

# Get enabled tool groups from environment
enabled_groups = ENV['TOOLS_ENABLED']&.downcase&.split(',')&.map(&:strip) || ['all']
enabled_groups = ['account', 'desk', 'front', 'reporting'] if enabled_groups.include?('all')

# Validate groups
valid_groups = ['account', 'desk', 'front', 'reporting']
enabled_groups = enabled_groups & valid_groups

if enabled_groups.empty?
  warn "Warning: No valid tool groups in TOOLS_ENABLED='#{ENV['TOOLS_ENABLED']}'. Using all groups."
  enabled_groups = valid_groups
end

# Load Pike13 tools only from enabled directories
enabled_groups.each do |group|
  Dir[File.join(__dir__, 'tools', group, '*.rb')].sort.each { |file| require file }
end

# Always load base tool
require File.join(__dir__, 'tools', 'base_tool.rb')

# Load Pike13 prompts
Dir[File.join(__dir__, 'prompts', '*.rb')].sort.each { |file| require file }

# Collect all tool classes
tool_classes = ObjectSpace.each_object(Class).select { |klass| klass < Pike13BaseTool }

# Collect all prompt classes
prompt_classes = ObjectSpace.each_object(Class).select { |klass| klass < MCP::Prompt && klass != MCP::Prompt }

# Get credentials from environment variables
server_context = {
  access_token: ENV['PIKE13_ACCESS_TOKEN'],
  base_url: ENV['PIKE13_BASE_URL']
}

# Create the MCP server
server = MCP::Server.new(
  name: 'pike13-mcp-server',
  version: '1.0.0',
  tools: tool_classes,
  prompts: prompt_classes,
  server_context: server_context
)

# Use stdio transport instead of HTTP
transport = MCP::Server::Transports::StdioTransport.new(server)
server.transport = transport

# Open the stdio transport (blocking loop)
transport.open

warn 'Starting Pike13 MCP Server (stdio mode)'
warn "Enabled tool groups: #{enabled_groups.join(', ')}"
warn "Loaded #{tool_classes.size} Pike13 tools"
warn "Loaded #{prompt_classes.size} Pike13 prompts"
warn 'Waiting for JSON-RPC requests on stdin/stdout...'
