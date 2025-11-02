# frozen_string_literal: true

require_relative "../base_tool"

class FrontListNotes < Pike13BaseTool
  description <<~DESC
    [CLIENT] List notes visible to customer for their account.
    Returns array of client-visible note objects.
    Use for customer self-service to view account notes or communications marked as customer-visible.
  DESC

  input_schema(
    properties: {
      person_id: { type: 'integer', description: 'Unique Pike13 person ID (integer)' }
    },
    required: ['person_id']
  )

  class << self
    def call(person_id:, server_context:)
      Pike13::Front::Note.all(person_id: person_id).to_json
    end
  end
end

class FrontGetNote < Pike13BaseTool
  description <<~DESC
    [CLIENT] Get specific note visible to customer.
    Returns note object if customer has permission to view.
    Use for customer self-service note access.
  DESC

  input_schema(
    properties: {
      person_id: { type: 'integer', description: 'Unique Pike13 person ID (integer)' },
      note_id: { type: 'integer', description: 'Unique note ID (integer)' }
    },
    required: ['person_id', 'note_id']
  )

  class << self
    def call(person_id:, note_id:, server_context:)
      Pike13::Front::Note.find(person_id: person_id, id: note_id).to_json
    end
  end
end
