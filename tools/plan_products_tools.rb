# frozen_string_literal: true

require_relative 'base_tool'

class Pike13FrontListPlanProducts < Pike13BaseTool
  description '[CLIENT] List plan products'

  def call
    client.front.plan_products.all.to_json
  end
end

class Pike13DeskListPlanProducts < Pike13BaseTool
  description '[STAFF] List all plan products'

  def call
    client.desk.plan_products.all.to_json
  end
end
