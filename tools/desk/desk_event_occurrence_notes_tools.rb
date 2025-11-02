# frozen_string_literal: true

require_relative '../base_tool'

class DeskListEventOccurrenceNotes < Pike13BaseTool
  description <<~DESC
    List all notes for an event occurrence (class session).
    Returns array of note objects with subject, content, author, timestamps.
    Use to view class-specific notes, instructor comments, or session details.
  DESC

  input_schema(
    properties: {
      event_occurrence_id: { type: 'integer', description: 'Unique Pike13 event occurrence ID (integer)' }
    },
    required: ['event_occurrence_id']
  )

  class << self
    def call(event_occurrence_id:, server_context:)
      Pike13::Desk::EventOccurrenceNote.all(event_occurrence_id: event_occurrence_id).to_json
    end
  end
end

class DeskGetEventOccurrenceNote < Pike13BaseTool
  description <<~DESC
    Get specific event occurrence note details.
    Returns note object with full content, subject, author, and timestamps.
    Use when you need complete details of a specific class note.
  DESC

  input_schema(
    properties: {
      event_occurrence_id: { type: 'integer', description: 'Unique Pike13 event occurrence ID (integer)' },
      note_id: { type: 'integer', description: 'Unique note ID (integer)' }
    },
    required: %w[event_occurrence_id note_id]
  )

  class << self
    def call(event_occurrence_id:, note_id:, server_context:)
      Pike13::Desk::EventOccurrenceNote.find(event_occurrence_id: event_occurrence_id, id: note_id).to_json
    end
  end
end

class DeskCreateEventOccurrenceNote < Pike13BaseTool
  description <<~DESC
    Create a new note for an event occurrence (class session).
    Requires "note" field (not "body") for content. Subject is optional but recommended.
    Returns created note object.
    Use for documenting class events, instructor observations, or session-specific information.
    WARNING: Use "note" parameter, not "body".
  DESC

  input_schema(
    properties: {
      event_occurrence_id: { type: 'integer', description: 'Unique Pike13 event occurrence ID (integer)' },
      note: { type: 'string', description: 'Note content text (use "note" not "body' },
      subject: { type: 'string', description: 'Optional: Note subject/title' },
      additional_attributes: { type: 'object', description: 'Optional: Additional note attributes' }
    },
    required: %w[event_occurrence_id note]
  )

  class << self
    def call(event_occurrence_id:, note:, server_context:, subject: nil, additional_attributes: nil)
      attributes = { note: note }
      attributes[:subject] = subject if subject
      attributes.merge!(additional_attributes) if additional_attributes

      Pike13::Desk::EventOccurrenceNote.create(
        event_occurrence_id: event_occurrence_id,
        attributes: attributes
      ).to_json
    end
  end
end

class DeskUpdateEventOccurrenceNote < Pike13BaseTool
  description <<~DESC
    Update an existing event occurrence note.
    Updates only provided fields.
    Returns updated note object.
    Use for editing class notes or session documentation.
    WARNING: Use "note" parameter for content, not "body".
  DESC

  input_schema(
    properties: {
      event_occurrence_id: { type: 'integer', description: 'Unique Pike13 event occurrence ID (integer)' },
      note_id: { type: 'integer', description: 'Unique note ID to update (integer)' },
      note: { type: 'string', description: 'Optional: Updated note content (use "note" not "body' },
      subject: { type: 'string', description: 'Optional: Updated note subject/title' },
      additional_attributes: { type: 'object', description: 'Optional: Additional attributes to update' }
    },
    required: %w[event_occurrence_id note_id]
  )

  class << self
    def call(event_occurrence_id:, note_id:, server_context:, note: nil, subject: nil, additional_attributes: nil)
      attributes = {}
      attributes[:note] = note if note
      attributes[:subject] = subject if subject
      attributes.merge!(additional_attributes) if additional_attributes

      Pike13::Desk::EventOccurrenceNote.update(
        event_occurrence_id: event_occurrence_id,
        id: note_id,
        attributes: attributes
      ).to_json
    end
  end
end

class DeskDeleteEventOccurrenceNote < Pike13BaseTool
  description <<~DESC
    Delete an event occurrence note.
    Permanently removes the class note.
    Returns success status.
    Use with caution - deletion is permanent.
  DESC

  input_schema(
    properties: {
      event_occurrence_id: { type: 'integer', description: 'Unique Pike13 event occurrence ID (integer)' },
      note_id: { type: 'integer', description: 'Unique note ID to delete (integer)' }
    },
    required: %w[event_occurrence_id note_id]
  )

  class << self
    def call(event_occurrence_id:, note_id:, server_context:)
      Pike13::Desk::EventOccurrenceNote.destroy(
        event_occurrence_id: event_occurrence_id,
        id: note_id
      ).to_json
    end
  end
end
