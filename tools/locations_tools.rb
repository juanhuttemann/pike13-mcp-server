# frozen_string_literal: true

require_relative 'base_tool'

class Pike13FrontListLocations < Pike13BaseTool
  description '[CLIENT] List locations'

  def call
    client.front.locations.all.to_json
  end
end

class Pike13DeskListLocations < Pike13BaseTool
  description '[STAFF] List all locations'

  def call
    client.desk.locations.all.to_json
  end
end
