# Pike13 MCP Server

MCP server for Pike13 API integration with stdio transport for Claude Desktop.

## Features

- **186 Pike13 API tools** across Front (Client), Desk (Staff), Account, and Reporting APIs
- **1 Prompt** for common workflows
- **Stdio transport** for direct Claude Desktop integration
- **Docker-based** deployment with minimal dependencies
- Support for all Pike13 API operations

## Installation

### Using Pre-built Image (Recommended)

```bash
docker pull juanhuttemann/pike13-mcp:latest
```

### Building from Source

```bash
# Clone the repository
git clone https://github.com/juanhuttemann/pike13-mcp-server.git
cd pike13-mcp-server

# Build the image
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
        "-i",
        "-a",
        "stdin",
        "-a",
        "stdout",
        "--rm",
        "--name",
        "pike13-mcp-stdio",
        "-e",
        "PIKE13_ACCESS_TOKEN=your_access_token_here",
        "-e",
        "PIKE13_BASE_URL=https://yourbusiness.pike13.com",
        "juanhuttemann/pike13-mcp:latest"
      ]
    }
  }
}
```

**Environment Variables:**
- `PIKE13_ACCESS_TOKEN`: Your Pike13 API access token
- `PIKE13_BASE_URL`: Your Pike13 business URL (e.g., `https://yourbusiness.pike13.com`)

After updating the config, **restart Claude Desktop** to activate the MCP server.

### Using with Local Build

If you built the image locally, change the last argument from `juanhuttemann/pike13-mcp:latest` to `pike13-mcp`:

```json
"args": [
  "run",
  "-i",
  "-a",
  "stdin",
  "-a",
  "stdout",
  "--rm",
  "--name",
  "pike13-mcp-stdio",
  "-e",
  "PIKE13_ACCESS_TOKEN=your_access_token_here",
  "-e",
  "PIKE13_BASE_URL=https://yourbusiness.pike13.com",
  "pike13-mcp"
]
```

## Available Tools

The server provides **186 tools** organized by Pike13 API:

### Front API (Client) - 65 tools
Tools prefixed with `Front` - for customer/public operations:
- **Business**: Get business info, branding, locations, franchisees
- **Profile**: Get current user profile
- **Events**: List events, event occurrences, availability, enrollment eligibilities
- **Visits**: List, get, create, update, delete visits
- **Services**: List services, enrollment eligibilities
- **Plans**: List plan products, plan terms
- **Invoices**: List, get, create, update invoices and items
- **Payments**: Create payments, get payment configuration
- **Staff**: List staff members, get staff details
- **Waitlist**: Manage waitlist entries
- **Bookings**: Full booking and booking lease management
- **Forms of Payment**: Manage payment methods
- **Notes**: List and get notes
- **Waivers**: List person waivers

### Desk API (Staff) - 103 tools
Tools prefixed with `Desk` - for staff/admin operations:
- **People**: List, search, get, create, update, delete people
- **Business**: Get business details, franchisees
- **Events**: Complete event and occurrence management
- **Visits**: Full visit CRUD operations
- **Services**: Service and enrollment management
- **Plans**: List plans, manage end dates, plan products
- **Punches**: Create, get, update, delete punches
- **Packs**: Manage packs and pack products
- **Invoices**: Full invoice management including items, discounts, prorates
- **Payments**: Process payments, void payments, payment configuration
- **Refunds**: Create and void refunds
- **Revenue Categories**: List and get revenue categories
- **Sales Taxes**: List and get sales taxes
- **Custom Fields**: List custom fields
- **Waitlist**: Full waitlist CRUD operations
- **Staff**: Staff member management
- **Locations**: List and get locations
- **Notes**: Full note CRUD operations
- **Forms of Payment**: Manage payment methods
- **Appointments**: Find available slots, get availability summary
- **Makeups**: Generate and get makeup credits

### Account API - 6 tools
Tools prefixed with `Account` - for account-level operations:
- **Businesses**: List all businesses in account
- **User**: Get account user info
- **People**: List all people across businesses
- **Password Reset**: Create password reset

### Reporting API - 12 tools
Tools prefixed with `Reporting` - for analytics and reporting operations:
- **Monthly Business Metrics**: Get business performance metrics
- **Event Occurrences**: Get event occurrence reports
- **Event Occurrence Staff Members**: Get staff assignment reports
- **Enrollments**: Get enrollment reports
- **Clients**: Get client reports
- **Staff Members**: Get staff reports
- **Invoices**: Get invoice reports
- **Invoice Items**: Get invoice item reports
- **Invoice Item Transactions**: Get transaction reports
- **Pays**: Get payment reports
- **Person Plans**: Get membership/plan reports
- **Transactions**: Get financial transaction reports
- **Confirmation**: Create confirmation

## Available Prompts

### search_client
Search for a client by name, email, or phone using DeskSearchPeople.

**Usage in Claude Desktop:**
1. Type `/search_client`
2. Enter the client name, email, or phone
3. Claude will search and show the results

## How It Works

The Pike13 MCP Server uses a **stdio transport** architecture:

1. **Ruby MCP Server**: Processes JSON-RPC requests via stdin/stdout
2. **Pike13 SDK**: Makes API calls to your Pike13 instance
3. **Direct Communication**: No HTTP or SSE - clean stdio-based protocol

This provides the simplest and most efficient integration with Claude Desktop.

## Project Structure

```
├── config/
│   └── pike13_client.rb    # Pike13 client configuration
├── tools/
│   ├── base_tool.rb        # Base tool with auto error handling
│   └── *_tools.rb          # Resource-specific tools (35 files, 186 tools)
├── prompts/
│   └── search_client_prompt.rb  # Example prompt
├── server.rb               # Ruby MCP server (stdio transport)
├── Dockerfile              # Minimal Alpine-based build
└── Gemfile                 # Only 2 gems: mcp, pike13
```

## Troubleshooting

### Claude Desktop shows "Server disconnected"
- Ensure Docker is running
- Verify environment variables are set correctly in the config
- Check that your Pike13 access token is valid
- Check Claude Desktop logs:
  - **macOS**: `~/Library/Logs/Claude/mcp-server-pike13.log`
  - **Windows**: `%APPDATA%\Claude\logs\mcp-server-pike13.log`

### Testing the server manually

Test that the server works with an initialize request:

```bash
echo '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"test","version":"1.0"}}}' | \
docker run -i --rm \
  -e PIKE13_ACCESS_TOKEN=your_token \
  -e PIKE13_BASE_URL=https://yourbusiness.pike13.com \
  juanhuttemann/pike13-mcp:latest
```

You should see a JSON response with server info and 186 tools.

Test listing all tools:

```bash
echo '{"jsonrpc":"2.0","id":2,"method":"tools/list"}' | \
docker run -i --rm \
  -e PIKE13_ACCESS_TOKEN=your_token \
  -e PIKE13_BASE_URL=https://yourbusiness.pike13.com \
  juanhuttemann/pike13-mcp:latest
```

### Getting Pike13 API Credentials

1. Log into your Pike13 account
2. Go to **Settings** → **Integrations** → **API Access**
3. Generate a new API access token
4. Copy your access token and business URL

## Development

### Running locally without Docker

```bash
bundle install

export PIKE13_ACCESS_TOKEN=your_token
export PIKE13_BASE_URL=https://yourbusiness.pike13.com

ruby server.rb
```

### Adding new tools

1. Create a new file in `tools/` following the pattern:

```ruby
class MyNewTool < Pike13BaseTool
  description "What this tool does"

  input_schema(
    properties: {
      param_name: { type: 'string', description: 'Parameter description' }
    },
    required: ['param_name']
  )

  class << self
    def call(param_name:, server_context:)
      # Your implementation using Pike13 SDK
      Pike13::SomeResource.some_method(param_name).to_json
    end
  end
end
```

2. Rebuild the Docker image
3. Restart Claude Desktop

### Adding new prompts

1. Create a new file in `prompts/`:

```ruby
class MyPrompt < MCP::Prompt
  prompt_name 'my_prompt'
  description 'What this prompt does'

  arguments [
    MCP::Prompt::Argument.new(
      name: 'param',
      description: 'Parameter description',
      required: true
    )
  ]

  class << self
    def template(args, server_context:)
      MCP::Prompt::Result.new(
        description: "Description",
        messages: [
          MCP::Prompt::Message.new(
            role: 'user',
            content: MCP::Content::Text.new("Your instruction to Claude using #{args[:param]}")
          )
        ]
      )
    end
  end
end
```

2. Rebuild and restart

## License

MIT
