# frozen_string_literal: true

require_relative 'base_tool'

class Pike13FrontListServices < Pike13BaseTool
  description '[CLIENT] List services'

  def call
    client.front.services.all.to_json
  end
end

class Pike13DeskListServices < Pike13BaseTool
  description '[STAFF] List all services'

  def call
    client.desk.services.all.to_json
  end
end
