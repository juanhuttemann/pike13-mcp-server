# frozen_string_literal: true

require_relative '../base_tool'

class FrontListNotes < Pike13BaseTool
  description "List customer notes"

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
  description "Get customer note"

  input_schema(
    properties: {
      person_id: { type: 'integer', description: 'Unique Pike13 person ID (integer)' },
      note_id: { type: 'integer', description: 'Unique note ID (integer)' }
    },
    required: %w[person_id note_id]
  )

  class << self
    def call(person_id:, note_id:, server_context:)
      Pike13::Front::Note.find(person_id: person_id, id: note_id).to_json
    end
  end
end
