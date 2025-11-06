# frozen_string_literal: true

require_relative '../base_tool'

class DeskListNotes < Pike13BaseTool
  description "List person notes."

  input_schema(
    properties: {
      person_id: { type: 'integer', description: 'Person ID' }
    },
    required: ['person_id']
  )

  class << self
    def call(person_id:, server_context:)
      Pike13::Desk::Note.all(person_id: person_id).to_json
    end
  end
end

class DeskGetNote < Pike13BaseTool
  description "Get note details."

  input_schema(
    properties: {
      person_id: { type: 'integer', description: 'Person ID' },
      note_id: { type: 'integer', description: 'Note ID' }
    },
    required: %w[person_id note_id]
  )

  class << self
    def call(person_id:, note_id:, server_context:)
      Pike13::Desk::Note.find(person_id: person_id, id: note_id).to_json
    end
  end
end

class DeskCreateNote < Pike13BaseTool
  description "Create note."

  input_schema(
    properties: {
      person_id: { type: 'integer', description: 'Person ID' },
      note: { type: 'string', description: 'Note content text (use "note" not "body")' },
      subject: { type: 'string', description: 'Optional: Note subject/title' },
      additional_attributes: { type: 'object',
                               description: 'Optional: Additional note attributes (e.g., visibility, category)' }
    },
    required: %w[person_id note]
  )

  class << self
    def call(person_id:, note:, server_context:, subject: nil, additional_attributes: nil)
      attributes = { note: note }
      attributes[:subject] = subject if subject
      attributes.merge!(additional_attributes) if additional_attributes

      Pike13::Desk::Note.create(person_id: person_id, attributes: attributes).to_json
    end
  end
end

class DeskUpdateNote < Pike13BaseTool
  description <<~DESC
    Update an existing note.
    Updates only provided fields.
    Returns updated note object.
    Use for editing note content or subject.
    WARNING: Use "note" parameter for content, not "body".
  DESC

  input_schema(
    properties: {
      person_id: { type: 'integer', description: 'Person ID' },
      note_id: { type: 'integer', description: 'Unique note ID to update (integer)' },
      note: { type: 'string', description: 'Optional: Updated note content (use "note" not "body")' },
      subject: { type: 'string', description: 'Optional: Updated note subject/title' },
      additional_attributes: { type: 'object', description: 'Optional: Additional attributes to update' }
    },
    required: %w[person_id note_id]
  )

  class << self
    def call(person_id:, note_id:, server_context:, note: nil, subject: nil, additional_attributes: nil)
      attributes = {}
      attributes[:note] = note if note
      attributes[:subject] = subject if subject
      attributes.merge!(additional_attributes) if additional_attributes

      Pike13::Desk::Note.update(person_id: person_id, id: note_id, attributes: attributes).to_json
    end
  end
end

class DeskDeleteNote < Pike13BaseTool
  description <<~DESC
    Delete a note.
    Permanently removes the note.
    Returns success status.
    Use with caution - deletion is permanent.
  DESC

  input_schema(
    properties: {
      person_id: { type: 'integer', description: 'Person ID' },
      note_id: { type: 'integer', description: 'Unique note ID to delete (integer)' }
    },
    required: %w[person_id note_id]
  )

  class << self
    def call(person_id:, note_id:, server_context:)
      Pike13::Desk::Note.destroy(person_id: person_id, id: note_id).to_json
    end
  end
end
