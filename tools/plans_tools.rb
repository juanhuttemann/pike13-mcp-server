# frozen_string_literal: true

require_relative 'base_tool'

class Pike13FrontListPlans < Pike13BaseTool
  description '[CLIENT] List plans'

  def call
    client.front.plans.all.to_json
  end
end

class Pike13DeskListPlans < Pike13BaseTool
  description '[STAFF] List all plans'

  def call
    client.desk.plans.all.to_json
  end
end
