#!/usr/bin/env ruby
# frozen_string_literal: true

require 'bundler/setup'
Bundler.require(:default)
require 'mcp'

# Load Pike13 tools
Dir[File.join(__dir__, 'tools', '**', '*.rb')].sort.each { |file| require file }

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
warn "Loaded #{tool_classes.size} Pike13 tools"
warn "Loaded #{prompt_classes.size} Pike13 prompts"
warn 'Waiting for JSON-RPC requests on stdin/stdout...'
