# frozen_string_literal: true

require_relative 'base_tool'

class Pike13FrontListEvents < Pike13BaseTool
  description '[CLIENT] List events'

  def call
    client.front.events.all.to_json
  end
end

class Pike13FrontGetEvent < Pike13BaseTool
  description '[CLIENT] Get event by ID'

  arguments do
    required(:event_id).filled(:integer).description('Event ID')
  end

  def call(event_id:)
    client.front.events.find(event_id).to_json
  end
end

class Pike13DeskListEvents < Pike13BaseTool
  description '[STAFF] List all events'

  def call
    client.desk.events.all.to_json
  end
end

class Pike13DeskGetEvent < Pike13BaseTool
  description '[STAFF] Get event by ID'

  arguments do
    required(:event_id).filled(:integer).description('Event ID')
  end

  def call(event_id:)
    client.desk.events.find(event_id).to_json
  end
end
