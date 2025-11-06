# frozen_string_literal: true

require_relative '../base_tool'

class DeskListEventOccurrenceNotes < Pike13BaseTool
  description "List event occurrence notes"

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
  description "Get event occurrence note details"

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
  description "Create event occurrence note - use 'note' field"

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
  description "Update event occurrence note"

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
  description "Delete event occurrence note"

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
