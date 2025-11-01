# frozen_string_literal: true

require 'mcp'

# Simple prompt to search for a client
class SearchClientPrompt < MCP::Prompt
  prompt_name 'search_client'
  description 'Search for a client by name, email, or phone using DeskSearchPeople'

  arguments [
    MCP::Prompt::Argument.new(
      name: 'query',
      description: 'Name, email, or phone number to search for',
      required: true
    )
  ]

  class << self
    def template(args, server_context:)
      query = args[:query]

      MCP::Prompt::Result.new(
        description: "Search for client: #{query}",
        messages: [
          MCP::Prompt::Message.new(
            role: 'user',
            content: MCP::Content::Text.new("Search for a Pike13 client named '#{query}' using the DeskSearchPeople tool. Show me their basic information.")
          )
        ]
      )
    end
  end
end
