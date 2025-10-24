# frozen_string_literal: true

require_relative 'base_tool'

class DeskGetPunch < Pike13BaseTool
  description '[STAFF ONLY] Get individual punch (class credit) by ID. Returns punch with pack reference, usage date, visit associated, and status. Use to verify punch usage, resolve billing disputes, or track pack consumption. Punches are single credits from class packs used for visits.'

  arguments do
    required(:punch_id).filled(:integer).description('Unique Pike13 punch ID (integer)')
  end

  def call(punch_id:)
    client.desk.punches.find(punch_id).to_json
  end
end
