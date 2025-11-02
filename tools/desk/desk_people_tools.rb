# frozen_string_literal: true

require_relative '../base_tool'

class DeskListPeople < Pike13BaseTool
  description <<~DESC
    [STAFF] List ALL clients - AVOID for searches.
    Returns huge dataset.
    Use ONLY for "all clients", "export clients", "client report".
    For finding specific people, use DeskSearchPeople instead.
  DESC

  class << self
    def call(server_context:)
      Pike13::Desk::Person.all.to_json
    end
  end
end

class DeskGetPerson < Pike13BaseTool
  description <<~DESC
    [STAFF] STEP 2: Get full client details after search.
    Returns: contact, memberships, billing, history.
    Use AFTER DeskSearchPeople to get complete profile.
    Workflow: DeskSearchPeople → DeskGetPerson → manage client (update, book, etc.)
  DESC

  input_schema(
    properties: {
      person_id: { type: 'integer', description: 'Unique Pike13 person ID (integer)' }
    },
    required: ['person_id']
  )

  class << self
    def call(person_id:, server_context:)
      Pike13::Desk::Person.find(person_id).to_json
    end
  end
end

class DeskSearchPeople < Pike13BaseTool
  description <<~DESC
    [STAFF] STEP 1: Find client by name/email/phone.
    Returns: [{person_id, name, email}].
    Use FIRST when you need to find someone.
    Workflow: DeskSearchPeople → DeskGetPerson for full details.
    AVOID DeskListPeople for searches.
  DESC

  input_schema(
    properties: {
      query: { type: 'string', description: 'Search term: name, email, or phone number (digits only for phone)' },
      fields: { type: 'string', description: 'Optional: comma-delimited fields to search (name, email, phone, barcodes). If not specified, all fields are searched.' }
    },
    required: ['query']
  )

  class << self
    def call(query:, fields: nil, server_context:)
      Pike13::Desk::Person.search(query, fields: fields).to_json
    end
  end
end

class DeskGetMe < Pike13BaseTool
  description <<~DESC
    [STAFF] Get current staff member profile and permissions.
    Returns: name, email, role, assigned locations, permissions.
    Use ONLY when staff asks "who am I", "my profile", "my permissions" or needs to verify their staff status.
    NOT needed for regular staff operations like managing clients, events, or appointments.
  DESC

  class << self
    def call(server_context:)
      Pike13::Desk::Person.me.to_json
    end
  end
end

class DeskCreatePerson < Pike13BaseTool
  description <<~DESC
    [STAFF] Create a new person (client/customer).
    Requires at minimum first_name, last_name, and email.
    Returns created person object with assigned ID.
    Use for new client registration or importing users.
  DESC

  input_schema(
    properties: {
      first_name: { type: 'string', description: 'Person first name' },
      last_name: { type: 'string', description: 'Person last name' },
      email: { type: 'string', description: 'Person email address' },
      phone: { type: 'string', description: 'Optional: Phone number' },
      additional_attributes: { type: 'object', description: 'Optional: Additional person attributes as a hash (e.g., address, emergency contacts, custom fields)' }
    },
    required: ['first_name', 'last_name', 'email']
  )

  class << self
    def call(first_name:, last_name:, email:, phone: nil, additional_attributes: nil, server_context:)
      attributes = {
        first_name: first_name,
        last_name: last_name,
        email: email
      }
      attributes[:phone] = phone if phone
      attributes.merge!(additional_attributes) if additional_attributes

      Pike13::Desk::Person.create(**attributes).to_json
    end
  end
end

class DeskUpdatePerson < Pike13BaseTool
  description <<~DESC
    [STAFF] Update an existing person profile.
    Updates only the provided fields.
    Returns updated person object.
    Use for profile edits, status changes, or custom field updates.
  DESC

  input_schema(
    properties: {
      person_id: { type: 'integer', description: 'Unique Pike13 person ID to update' },
      first_name: { type: 'string', description: 'Optional: Update first name' },
      last_name: { type: 'string', description: 'Optional: Update last name' },
      email: { type: 'string', description: 'Optional: Update email address' },
      phone: { type: 'string', description: 'Optional: Update phone number' },
      additional_attributes: { type: 'object', description: 'Optional: Additional attributes to update as a hash' }
    },
    required: ['person_id']
  )

  class << self
    def call(person_id:, first_name: nil, last_name: nil, email: nil, phone: nil, additional_attributes: nil, server_context:)
      attributes = {}
      attributes[:first_name] = first_name if first_name
      attributes[:last_name] = last_name if last_name
      attributes[:email] = email if email
      attributes[:phone] = phone if phone
      attributes.merge!(additional_attributes) if additional_attributes

      Pike13::Desk::Person.update(person_id, **attributes).to_json
    end
  end
end

class DeskDeletePerson < Pike13BaseTool
  description <<~DESC
    [STAFF] Delete (archive) a person.
    This typically archives the person rather than permanently deleting.
    Returns success status.
    Use with caution - ensure person has no active bookings or memberships.
  DESC

  input_schema(
    properties: {
      person_id: { type: 'integer', description: 'Unique Pike13 person ID to delete' }
    },
    required: ['person_id']
  )

  class << self
    def call(person_id:, server_context:)
      Pike13::Desk::Person.destroy(person_id).to_json
    end
  end
end
