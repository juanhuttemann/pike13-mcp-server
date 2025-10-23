# frozen_string_literal: true

require_relative 'base_tool'

class Pike13DeskGetPack < Pike13BaseTool
  description '[STAFF ONLY] Get owned class pack by ID. Returns pack instance (owned by customer) with punch count remaining, expiration date, purchase info, service restrictions, and usage history. Use to check pack balance, verify eligibility, or manage customer packs. Packs contain punches used for visits.'

  arguments do
    required(:pack_id).filled(:integer).description('Unique Pike13 pack ID (integer)')
  end

  def call(pack_id:)
    client.desk.packs.find(pack_id).to_json
  end
end
