# frozen_string_literal: true

require_relative 'base_tool'

class Pike13DeskGetPunch < Pike13BaseTool
  description '[STAFF ONLY] Get punch by ID'

  arguments do
    required(:punch_id).filled(:integer).description('Punch ID')
  end

  def call(punch_id:)
    client.desk.punches.find(punch_id).to_json
  end
end
