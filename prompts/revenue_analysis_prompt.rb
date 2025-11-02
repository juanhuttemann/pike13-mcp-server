# frozen_string_literal: true

require 'mcp'

# Simple prompt for analyzing top revenue products
class RevenueAnalysisPrompt < MCP::Prompt
  prompt_name 'top_products'
  description 'Get top performing products by revenue'

  arguments [
    MCP::Prompt::Argument.new(
      name: 'limit',
      description: 'Number of products to show (5-20, default: 10)',
      required: false
    )
  ]

  class << self
    def template(args, server_context:)
      limit = (args[:limit] || 10).to_i.clamp(5, 20)

      MCP::Prompt::Result.new(
        description: "Get top #{limit} products by revenue",
        messages: [
          MCP::Prompt::Message.new(
            role: 'user',
            content: MCP::Content::Text.new(<<~PROMPT)
              Show me the top #{limit} products by revenue using ReportingInvoiceItems.

              Group by product_name and get:
              - product_name
              - total_gross_amount
              - invoice_item_count
              Sort by total_gross_amount descending
              Limit to #{limit} results

              Tell me:
              1. Which product makes the most money
              2. How many units sold for each
              3. Average price per unit
              4. Any surprises in the top products
            PROMPT
          )
        ]
      )
    end
  end
end