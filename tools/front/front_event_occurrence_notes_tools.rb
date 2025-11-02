# frozen_string_literal: true

require_relative '../base_tool'

class FrontListEventOccurrenceNotes < Pike13BaseTool
  description <<~DESC
    List customer-visible notes for an event occurrence (class session).
    Returns array of client-visible note objects.
    Use for customer self-service to view class announcements or session information.
  DESC

  input_schema(
    properties: {
      event_occurrence_id: { type: 'integer', description: 'Unique Pike13 event occurrence ID (integer)' }
    },
    required: ['event_occurrence_id']
  )

  class << self
    def call(event_occurrence_id:, server_context:)
      Pike13::Front::EventOccurrenceNote.all(event_occurrence_id: event_occurrence_id).to_json
    end
  end
end

class FrontGetEventOccurrenceNote < Pike13BaseTool
  description <<~DESC
    Get specific customer-visible event occurrence note.
    Returns note object if customer has permission to view.
    Use for customer access to class notes or announcements.
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
      Pike13::Front::EventOccurrenceNote.find(
        event_occurrence_id: event_occurrence_id,
        id: note_id
      ).to_json
    end
  end
end
