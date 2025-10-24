# frozen_string_literal: true

require_relative 'base_tool'

class FrontGetWaitlistEntry < Pike13BaseTool
  description '[CLIENT] Get customer waitlist entry by ID. Returns waitlist status for full event occurrence with position, event details, and notification preferences. Use to show customers their waitlist position or manage waitlist entries. Only returns entries for authenticated customer.'

  arguments do
    required(:entry_id).filled(:integer).description('Unique Pike13 waitlist entry ID (integer)')
  end

  def call(entry_id:)
    client.front.waitlist_entries.find(entry_id).to_json
  end
end

class DeskListWaitlistEntries < Pike13BaseTool
  description '[STAFF] List all waitlist entries. Returns waitlist entries with customer, event occurrence, position, join date, and notification status. Use for waitlist management, filling open spots, or understanding demand for full classes.'

  def call
    client.desk.waitlist_entries.all.to_json
  end
end
