# frozen_string_literal: true

require_relative 'base_tool'

# Account-level tools
class AccountGetMe < Pike13BaseTool
  description '[ACCOUNT] Get account-level user info ONLY. Returns account object with ID, email, name. Use ONLY when user asks about their account, billing, or businesses they own. NOT needed for regular business operations like booking, events, or services.'

  def call
    Pike13::Account.me.to_json
  end
end

class AccountListPeople < Pike13BaseTool
  description '[ACCOUNT] List all people across all businesses in the account. Returns paginated array of person objects from all associated businesses. Use for account-wide user management or reporting across multiple businesses.'

  def call
    Pike13::Account::Person.all.to_json
  end
end

# Front (CLIENT) tools
class FrontGetMe < Pike13BaseTool
  description '[CLIENT] Get current customer profile details. Returns: name, email, phone, emergency contacts, profile photo, active memberships. Use ONLY when user asks "who am I", "my profile", "my info" or wants to view/edit their personal details. NOT needed for booking, viewing services, or regular customer operations.'

  def call
    Pike13::Front::Person.me.to_json
  end
end

# Desk (STAFF) tools
class DeskListPeople < Pike13BaseTool
  description '[STAFF] List ALL clients - AVOID for searches. Returns huge dataset. Use ONLY for "all clients", "export clients", "client report". For finding specific people, use DeskSearchPeople instead.'

  def call
    Pike13::Desk::Person.all.to_json
  end
end

class DeskGetPerson < Pike13BaseTool
  description '[STAFF] STEP 2: Get full client details after search. Returns: contact, memberships, billing, history. Use AFTER DeskSearchPeople to get complete profile. Workflow: DeskSearchPeople → DeskGetPerson → manage client (update, book, etc.)'

  arguments do
    required(:person_id).filled(:integer).description('Unique Pike13 person ID (integer)')
  end

  def call(person_id:)
    Pike13::Desk::Person.find(person_id).to_json
  end
end

class DeskSearchPeople < Pike13BaseTool
  description '[STAFF] STEP 1: Find client by name/email/phone. Returns: [{person_id, name, email}]. Use FIRST when you need to find someone. Workflow: DeskSearchPeople → DeskGetPerson for full details. AVOID DeskListPeople for searches.'

  arguments do
    required(:query).filled(:string).description('Search term: name, email, or phone number')
  end

  def call(query:)
    Pike13::Desk::Person.search(query).to_json
  end
end

class DeskGetMe < Pike13BaseTool
  description '[STAFF] Get current staff member profile and permissions. Returns: name, email, role, assigned locations, permissions. Use ONLY when staff asks "who am I", "my profile", "my permissions" or needs to verify their staff status. NOT needed for regular staff operations like managing clients, events, or appointments.'

  def call
    Pike13::Desk::Person.me.to_json
  end
end

class DeskCreatePerson < Pike13BaseTool
  description '[STAFF] Create a new person (client/customer). Requires at minimum first_name, last_name, and email. Returns created person object with assigned ID. Use for new client registration or importing users.'

  arguments do
    required(:first_name).filled(:string).description('Person first name')
    required(:last_name).filled(:string).description('Person last name')
    required(:email).filled(:string).description('Person email address')
    optional(:phone).maybe(:string).description('Optional: Phone number')
    optional(:additional_attributes).maybe(:hash).description('Optional: Additional person attributes as a hash (e.g., address, emergency contacts, custom fields)')
  end

  def call(first_name:, last_name:, email:, phone: nil, additional_attributes: nil)
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

class DeskUpdatePerson < Pike13BaseTool
  description '[STAFF] Update an existing person profile. Updates only the provided fields. Returns updated person object. Use for profile edits, status changes, or custom field updates.'

  arguments do
    required(:person_id).filled(:integer).description('Unique Pike13 person ID to update')
    optional(:first_name).maybe(:string).description('Optional: Update first name')
    optional(:last_name).maybe(:string).description('Optional: Update last name')
    optional(:email).maybe(:string).description('Optional: Update email address')
    optional(:phone).maybe(:string).description('Optional: Update phone number')
    optional(:additional_attributes).maybe(:hash).description('Optional: Additional attributes to update as a hash')
  end

  def call(person_id:, first_name: nil, last_name: nil, email: nil, phone: nil, additional_attributes: nil)
    attributes = {}
    attributes[:first_name] = first_name if first_name
    attributes[:last_name] = last_name if last_name
    attributes[:email] = email if email
    attributes[:phone] = phone if phone
    attributes.merge!(additional_attributes) if additional_attributes

    Pike13::Desk::Person.update(person_id, **attributes).to_json
  end
end

class DeskDeletePerson < Pike13BaseTool
  description '[STAFF] Delete (archive) a person. This typically archives the person rather than permanently deleting. Returns success status. Use with caution - ensure person has no active bookings or memberships.'

  arguments do
    required(:person_id).filled(:integer).description('Unique Pike13 person ID to delete')
  end

  def call(person_id:)
    Pike13::Desk::Person.destroy(person_id).to_json
  end
end
