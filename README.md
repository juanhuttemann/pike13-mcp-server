# Pike13 MCP Server

MCP server for Pike13 API integration with stdio transport for Claude Desktop.

## Features

- 174 Pike13 API tools across Front (Client), Desk (Staff), and Account APIs
- Integrated supergateway for seamless Claude Desktop compatibility
- Docker-based deployment with automatic SSE→stdio conversion
- Support for all Pike13 API operations

## Installation

### Prerequisites
- Docker

### Build

```bash
# Build the image
docker compose build

# Or build manually
docker build -t pike13-mcp .
```

## Usage

### Claude Desktop Configuration

Add to your Claude Desktop config file:
- **macOS**: `~/Library/Application Support/Claude/claude_desktop_config.json`
- **Windows**: `%APPDATA%\Claude\claude_desktop_config.json`

```json
{
  "mcpServers": {
    "pike13": {
      "command": "docker",
      "args": [
        "run",
        "--name",
        "pike13-mcp-stdio",
        "-i",
        "--rm",
        "-e",
        "PIKE13_ACCESS_TOKEN=your_access_token_here",
        "-e",
        "PIKE13_BASE_URL=https://yourbusiness.pike13.com",
        "pike13-mcp"
      ]
    }
  }
}
```

**Environment Variables:**
- `PIKE13_ACCESS_TOKEN`: Your Pike13 API access token
- `PIKE13_BASE_URL`: Your Pike13 business URL (e.g., `https://yourbusiness.pike13.com`)

After updating the config, **restart Claude Desktop** to activate the MCP server.

## Available Tools

The server provides **174 tools** organized by Pike13 API:

### Front API (Client) - 65 tools
Tools prefixed with `Front` - for customer/public operations:
- **Business**: Get business info, branding, locations
- **Profile**: Get current user, appointments
- **Events**: List events, event occurrences, availability
- **Visits**: List, get, create, delete visits
- **Services**: List services, enrollment eligibilities
- **Products**: List plan products, invoices
- **Staff**: List staff members
- **Waitlist**: Manage waitlist entries
- **Bookings**: Get booking details

### Desk API (Staff) - 103 tools
Tools prefixed with `Desk` - for staff/admin operations:
- **People**: List, search, get, manage people
- **Business**: Get business details
- **Events**: Complete event and occurrence management
- **Visits**: Full visit CRUD operations
- **Services**: Service and enrollment management
- **Plans**: List plans, manage end dates, punches
- **Products**: Plan products, pack products
- **Financial**: Invoices, revenue categories, sales taxes, refunds
- **Custom Fields**: List custom fields
- **Waitlist**: Full waitlist CRUD operations
- **Staff**: Staff member management
- **Packs**: Get pack details

### Account API - 6 tools
Tools prefixed with `Account` - for account-level operations:
- **Businesses**: List all businesses
- **User**: Get current user info

## How It Works

The Docker container integrates two components:
1. **Ruby MCP Server** (background): Serves Pike13 API tools via SSE on localhost:9292
2. **Supergateway** (foreground): Converts SSE to stdio for Claude Desktop compatibility

This architecture provides clean JSON-RPC communication over stdin/stdout that Claude Desktop expects.

## Project Structure

```
├── config/
│   └── pike13_client.rb    # Pike13 client configuration
├── tools/
│   ├── base_tool.rb        # Base tool class
│   └── *_tools.rb          # Resource-specific tools (77 tools total)
├── server.rb               # Ruby MCP server (SSE transport)
├── start.sh                # Docker entrypoint (integrates supergateway)
├── Dockerfile              # Multi-stage build with Ruby + Node.js
└── docker-compose.yml      # Docker Compose configuration
```

## Troubleshooting

### Claude Desktop shows "Server disconnected"
- Ensure Docker is running
- Verify environment variables are set correctly in the config
- Check Claude Desktop logs:
  - **macOS**: `~/Library/Logs/Claude/mcp-server-pike13.log`
  - **Windows**: `%APPDATA%\Claude\logs\mcp-server-pike13.log`

### Container fails to start
```bash
# View container logs
docker logs pike13-mcp-stdio

# Rebuild the container
docker compose down
docker compose build --no-cache
```

### Testing the container manually
```bash
# Test that the container works
echo '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"test","version":"1.0"}}}' | \
docker run -i --rm \
  -e PIKE13_ACCESS_TOKEN=your_token \
  -e PIKE13_BASE_URL=https://yourbusiness.pike13.com \
  pike13-mcp
```

You should see a clean JSON response with the server info.

## License

MIT
