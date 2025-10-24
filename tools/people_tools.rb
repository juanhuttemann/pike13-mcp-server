# frozen_string_literal: true

require_relative 'base_tool'

class AccountGetMe < Pike13BaseTool
  description '[ACCOUNT] Get current authenticated account. Returns account object with ID, email, name, and associated person IDs across businesses. Use to identify the current user at account level before accessing business-specific data.'

  def call
    client.account.me.to_json
  end
end

class FrontGetMe < Pike13BaseTool
  description '[CLIENT] Get authenticated customer profile. Returns client-visible person details: name, email, phone, emergency contacts, profile photo, and active memberships. Use for customer self-service features like profile viewing/editing.'

  def call
    client.front.people.me.to_json
  end
end

class DeskListPeople < Pike13BaseTool
  description '[STAFF] List all people (clients/customers) in the business. Returns paginated array of person objects with contact info, status, membership details, and custom fields. Use for staff directories, bulk operations, or reporting. Warning: may return large datasets.'

  def call
    client.desk.people.all.to_json
  end
end

class DeskGetPerson < Pike13BaseTool
  description '[STAFF] Get detailed person profile by ID. Returns complete person record: contact details, emergency contacts, memberships, billing info, custom fields, notes, and activity history. Use when you have a person_id and need full profile data.'

  arguments do
    required(:person_id).filled(:integer).description('Unique Pike13 person ID (integer)')
  end

  def call(person_id:)
    client.desk.people.find(person_id).to_json
  end
end

class DeskSearchPeople < Pike13BaseTool
  description '[STAFF] Search for people by name, email, or phone. Returns matching person objects with relevance ranking. Use when you have partial user info (like "John Smith" or "john@example.com") and need to find their person_id or profile.'

  arguments do
    required(:query).filled(:string).description('Search term: name, email, or phone number')
  end

  def call(query:)
    client.desk.people.search(query).to_json
  end
end

class DeskGetMe < Pike13BaseTool
  description '[STAFF] Get authenticated staff member profile. Returns staff person object with employment details, permissions, schedule access, and full profile. Use for staff self-service features or identifying current staff member context.'

  def call
    client.desk.people.me.to_json
  end
end
