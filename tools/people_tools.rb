# frozen_string_literal: true

require_relative 'base_tool'

class Pike13AccountGetMe < Pike13BaseTool
  description '[ACCOUNT] Get current user'

  def call
    client.account.people.me.to_json
  end
end

class Pike13FrontGetMe < Pike13BaseTool
  description '[CLIENT] Get my profile'

  def call
    client.front.people.me.to_json
  end
end

class Pike13DeskListPeople < Pike13BaseTool
  description '[STAFF] List all people'

  def call
    client.desk.people.all.to_json
  end
end

class Pike13DeskGetPerson < Pike13BaseTool
  description '[STAFF] Get person by ID'

  arguments do
    required(:person_id).filled(:integer).description('Person ID')
  end

  def call(person_id:)
    client.desk.people.find(person_id).to_json
  end
end

class Pike13DeskSearchPeople < Pike13BaseTool
  description '[STAFF] Search people'

  arguments do
    required(:query).filled(:string).description('Search query')
  end

  def call(query:)
    client.desk.people.search(query).to_json
  end
end

class Pike13DeskGetMe < Pike13BaseTool
  description '[STAFF] Get my staff profile'

  def call
    client.desk.people.me.to_json
  end
end
