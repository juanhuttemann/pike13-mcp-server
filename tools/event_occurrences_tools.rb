# frozen_string_literal: true

require_relative 'base_tool'

class Pike13FrontListEventOccurrences < Pike13BaseTool
  description '[CLIENT] List event occurrences'

  arguments do
    required(:from).filled(:string).description('Start date YYYY-MM-DD')
    required(:to).filled(:string).description('End date YYYY-MM-DD')
  end

  def call(from:, to:)
    client.front.event_occurrences.all(from: from, to: to).to_json
  end
end

class Pike13FrontGetEventOccurrence < Pike13BaseTool
  description '[CLIENT] Get event occurrence by ID'

  arguments do
    required(:occurrence_id).filled(:integer).description('Occurrence ID')
  end

  def call(occurrence_id:)
    client.front.event_occurrences.find(occurrence_id).to_json
  end
end

class Pike13DeskListEventOccurrences < Pike13BaseTool
  description '[STAFF] List event occurrences'

  arguments do
    required(:from).filled(:string).description('Start date YYYY-MM-DD')
    required(:to).filled(:string).description('End date YYYY-MM-DD')
  end

  def call(from:, to:)
    client.desk.event_occurrences.all(from: from, to: to).to_json
  end
end

class Pike13DeskGetEventOccurrence < Pike13BaseTool
  description '[STAFF] Get event occurrence by ID'

  arguments do
    required(:occurrence_id).filled(:integer).description('Occurrence ID')
  end

  def call(occurrence_id:)
    client.desk.event_occurrences.find(occurrence_id).to_json
  end
end
