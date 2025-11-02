# frozen_string_literal: true

require 'mcp'

# Simple prompt for getting monthly business metrics
class MonthlyBusinessPerformancePrompt < MCP::Prompt
  prompt_name 'monthly_metrics'
  description 'Get monthly business metrics like revenue, new clients, and member count'

  arguments [
    MCP::Prompt::Argument.new(
      name: 'months',
      description: 'Number of months to show (1-12, default: 6)',
      required: false
    )
  ]

  class << self
    def template(args, server_context:)
      months = (args[:months] || 6).to_i.clamp(1, 12)

      MCP::Prompt::Result.new(
        description: "Get monthly business metrics for last #{months} months",
        messages: [
          MCP::Prompt::Message.new(
            role: 'user',
            content: MCP::Content::Text.new(<<~PROMPT)
              Show me monthly business metrics for the last #{months} months using ReportingMonthlyBusinessMetrics.

              Get these fields: month_start_date, net_paid_amount, new_client_count, member_count
              Sort by month_start_date descending
              Limit to #{months} results

              Tell me:
              1. Which month had the highest revenue
              2. How many new clients we got each month
              3. Member count trends
              4. Any noticeable patterns
            PROMPT
          )
        ]
      )
    end
  end
end