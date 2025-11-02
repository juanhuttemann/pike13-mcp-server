# frozen_string_literal: true

require 'mcp'

# Simple prompt for analyzing staff workload
class StaffPerformancePrompt < MCP::Prompt
  prompt_name 'staff_workload'
  description 'Get staff workload and enrollment statistics'

  arguments [
    MCP::Prompt::Argument.new(
      name: 'limit',
      description: 'Number of staff to show (5-15, default: 10)',
      required: false
    )
  ]

  class << self
    def template(args, server_context:)
      limit = (args[:limit] || 10).to_i.clamp(5, 15)

      MCP::Prompt::Result.new(
        description: "Get workload stats for top #{limit} staff",
        messages: [
          MCP::Prompt::Message.new(
            role: 'user',
            content: MCP::Content::Text.new(<<~PROMPT)
              Show me staff workload statistics using ReportingEventOccurrenceStaffMembers.

              Group by full_name and get:
              - full_name
              - total_enrollment_count
              - service_count
              Sort by total_enrollment_count descending
              Limit to #{limit} results

              Tell me:
              1. Who has the most enrollments
              2. How many services each person handles
              3. Average enrollments per service
              4. Any workload imbalances
            PROMPT
          )
        ]
      )
    end
  end
end