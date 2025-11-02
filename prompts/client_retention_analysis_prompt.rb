# frozen_string_literal: true

require 'mcp'

# Simple prompt for analyzing membership plans
class ClientRetentionAnalysisPrompt < MCP::Prompt
  prompt_name 'membership_plans'
  description 'Get membership plan usage and performance'

  arguments [
    MCP::Prompt::Argument.new(
      name: 'limit',
      description: 'Number of plans to show (5-15, default: 10)',
      required: false
    )
  ]

  class << self
    def template(args, server_context:)
      limit = (args[:limit] || 10).to_i.clamp(5, 15)

      MCP::Prompt::Result.new(
        description: "Get top #{limit} membership plans by usage",
        messages: [
          MCP::Prompt::Message.new(
            role: 'user',
            content: MCP::Content::Text.new(<<~PROMPT)
              Show me membership plan performance using ReportingPersonPlans.

              Group by plan_name and get:
              - plan_name
              - plan_type
              - total_used_visit_count
              - is_available
              - is_on_hold
              Sort by total_used_visit_count descending
              Limit to #{limit} results

              Tell me:
              1. Which plans are most popular
              2. How many visits each plan type gets
              3. Which plans are currently available
              4. Any plans on hold
              5. Most used vs least used plans
            PROMPT
          )
        ]
      )
    end
  end
end