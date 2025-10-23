# frozen_string_literal: true

require_relative 'base_tool'

class Pike13DeskGetPack < Pike13BaseTool
  description '[STAFF ONLY] Get pack by ID'

  arguments do
    required(:pack_id).filled(:integer).description('Pack ID')
  end

  def call(pack_id:)
    client.desk.packs.find(pack_id).to_json
  end
end
