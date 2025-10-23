# frozen_string_literal: true

require_relative 'base_tool'

class Pike13FrontGetWaitlistEntry < Pike13BaseTool
  description '[CLIENT] Get waitlist entry by ID'

  arguments do
    required(:entry_id).filled(:integer).description('Entry ID')
  end

  def call(entry_id:)
    client.front.waitlist_entries.find(entry_id).to_json
  end
end

class Pike13DeskListWaitlistEntries < Pike13BaseTool
  description '[STAFF] List all waitlist entries'

  def call
    client.desk.waitlist_entries.all.to_json
  end
end
