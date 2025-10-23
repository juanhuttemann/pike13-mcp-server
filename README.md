# Pike13 MCP Server

MCP server for Pike13 API integration.

## Installation

```bash
bundle install
```

## Configuration

Add to your MCP client config:

```json
{
  "mcpServers": {
    "pike13": {
      "url": "http://localhost:9292/mcp/sse",
      "headers": {
        "X-Pike13-Access-Token": "your_access_token_here",
        "X-Pike13-Base-URL": "yourbusiness.pike13.com"
      }
    }
  }
}
```

## Running

### Local
```bash
ruby server.rb
```

### Docker
```bash
# Build and run
docker build -t pike13-mcp .
docker run -d -p 9292:9292 pike13-mcp

# Or with docker compose
docker compose up -d
```

Server starts on `http://localhost:9292`

## Tools

### Front API (Client)
Tools prefixed with `[CLIENT]` - for customer/public operations:
- Business info, branding
- My profile, appointments, visits
- Events, locations, services
- Plans, invoices, bookings

### Desk API (Staff)
Tools prefixed with `[STAFF]` - for staff/admin operations:
- All people management
- Complete business data
- Financial data, invoices
- Custom fields, revenue categories

### Account API
Tools prefixed with `[ACCOUNT]` - for account-level operations:
- List businesses
- Current user info

## Structure

```
├── config/
│   └── pike13_client.rb    # Pike13 client configuration
├── tools/
│   ├── base_tool.rb        # Base tool class
│   └── *_tools.rb          # Resource-specific tools
└── server.rb               # MCP server
```
