# frozen_string_literal: true

require_relative 'base_tool'

class Pike13FrontListVisits < Pike13BaseTool
  description '[CLIENT] List my visits'

  def call
    client.front.visits.all.to_json
  end
end

class Pike13FrontGetVisit < Pike13BaseTool
  description '[CLIENT] Get visit by ID'

  arguments do
    required(:visit_id).filled(:integer).description('Visit ID')
  end

  def call(visit_id:)
    client.front.visits.find(visit_id).to_json
  end
end

class Pike13DeskListVisits < Pike13BaseTool
  description '[STAFF] List all visits'

  arguments do
    optional(:person_id).maybe(:integer).description('Optional: filter by person ID')
  end

  def call(person_id: nil)
    visits = person_id ? client.desk.visits.all(person_id: person_id) : client.desk.visits.all
    visits.to_json
  end
end

class Pike13DeskGetVisit < Pike13BaseTool
  description '[STAFF] Get visit by ID'

  arguments do
    required(:visit_id).filled(:integer).description('Visit ID')
  end

  def call(visit_id:)
    client.desk.visits.find(visit_id).to_json
  end
end
