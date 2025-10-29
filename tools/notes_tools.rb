# frozen_string_literal: true

require_relative 'base_tool'

class DeskListNotes < Pike13BaseTool
  description '[STAFF] List all notes for a person. Returns array of note objects with subject, note content, author, timestamps, and visibility settings. Use to view communication history, customer service notes, or account annotations.'

  arguments do
    required(:person_id).filled(:integer).description('Unique Pike13 person ID (integer)')
  end

  def call(person_id:)
    Pike13::Desk::Note.all(person_id: person_id).to_json
  end
end

class DeskGetNote < Pike13BaseTool
  description '[STAFF] Get specific note details. Returns note object with full content, subject, author, timestamps, and visibility. Use when you need complete details of a specific note.'

  arguments do
    required(:person_id).filled(:integer).description('Unique Pike13 person ID (integer)')
    required(:note_id).filled(:integer).description('Unique note ID (integer)')
  end

  def call(person_id:, note_id:)
    Pike13::Desk::Note.find(person_id: person_id, id: note_id).to_json
  end
end

class DeskCreateNote < Pike13BaseTool
  description '[STAFF] Create a new note for a person. Requires "note" field (not "body") for content. Subject is optional but recommended. Returns created note object. Use for documenting customer interactions, service notes, or account annotations. WARNING: Use "note" parameter, not "body".'

  arguments do
    required(:person_id).filled(:integer).description('Unique Pike13 person ID (integer)')
    required(:note).filled(:string).description('Note content text (use "note" not "body")')
    optional(:subject).maybe(:string).description('Optional: Note subject/title')
    optional(:additional_attributes).maybe(:hash).description('Optional: Additional note attributes (e.g., visibility, category)')
  end

  def call(person_id:, note:, subject: nil, additional_attributes: nil)
    attributes = { note: note }
    attributes[:subject] = subject if subject
    attributes.merge!(additional_attributes) if additional_attributes

    Pike13::Desk::Note.create(person_id: person_id, attributes: attributes).to_json
  end
end

class DeskUpdateNote < Pike13BaseTool
  description '[STAFF] Update an existing note. Updates only provided fields. Returns updated note object. Use for editing note content or subject. WARNING: Use "note" parameter for content, not "body".'

  arguments do
    required(:person_id).filled(:integer).description('Unique Pike13 person ID (integer)')
    required(:note_id).filled(:integer).description('Unique note ID to update (integer)')
    optional(:note).maybe(:string).description('Optional: Updated note content (use "note" not "body")')
    optional(:subject).maybe(:string).description('Optional: Updated note subject/title')
    optional(:additional_attributes).maybe(:hash).description('Optional: Additional attributes to update')
  end

  def call(person_id:, note_id:, note: nil, subject: nil, additional_attributes: nil)
    attributes = {}
    attributes[:note] = note if note
    attributes[:subject] = subject if subject
    attributes.merge!(additional_attributes) if additional_attributes

    Pike13::Desk::Note.update(person_id: person_id, id: note_id, attributes: attributes).to_json
  end
end

class DeskDeleteNote < Pike13BaseTool
  description '[STAFF] Delete a note. Permanently removes the note. Returns success status. Use with caution - deletion is permanent.'

  arguments do
    required(:person_id).filled(:integer).description('Unique Pike13 person ID (integer)')
    required(:note_id).filled(:integer).description('Unique note ID to delete (integer)')
  end

  def call(person_id:, note_id:)
    Pike13::Desk::Note.destroy(person_id: person_id, id: note_id).to_json
  end
end

class FrontListNotes < Pike13BaseTool
  description '[CLIENT] List notes visible to customer for their account. Returns array of client-visible note objects. Use for customer self-service to view account notes or communications marked as customer-visible.'

  arguments do
    required(:person_id).filled(:integer).description('Unique Pike13 person ID (integer)')
  end

  def call(person_id:)
    Pike13::Front::Note.all(person_id: person_id).to_json
  end
end

class FrontGetNote < Pike13BaseTool
  description '[CLIENT] Get specific note visible to customer. Returns note object if customer has permission to view. Use for customer self-service note access.'

  arguments do
    required(:person_id).filled(:integer).description('Unique Pike13 person ID (integer)')
    required(:note_id).filled(:integer).description('Unique note ID (integer)')
  end

  def call(person_id:, note_id:)
    Pike13::Front::Note.find(person_id: person_id, id: note_id).to_json
  end
end
