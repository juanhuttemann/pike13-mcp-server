#!/bin/sh
set -e

# Start the Ruby MCP server in the background, redirect its output to stderr
ruby /app/server.rb >/dev/null 2>&1 &
SERVER_PID=$!

# Wait for the server to be ready
sleep 3

# Start supergateway to convert SSE to stdio
# Only supergateway's output goes to stdout (clean JSON-RPC)
exec supergateway \
  --sse "http://localhost:9292/mcp/sse" \
  --header "X-Pike13-Access-Token: ${PIKE13_ACCESS_TOKEN}" \
  --header "X-Pike13-Base-URL: ${PIKE13_BASE_URL}" \
  --logLevel none
