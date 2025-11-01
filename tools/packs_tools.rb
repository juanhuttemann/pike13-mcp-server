# frozen_string_literal: true

require_relative 'base_tool'

class DeskListPacks < Pike13BaseTool
  description <<~DESC
    [STAFF] List all pack instances.
    Returns all packs owned by customers with remaining punches, expiration dates, and usage history.
    Use for pack management, reporting, or finding specific customer packs.
  DESC

  class << self
    def call(server_context:)
      Pike13::Desk::Pack.all.to_json
    end
  end
end

class DeskGetPack < Pike13BaseTool
  description <<~DESC
    [STAFF ONLY] Get owned class pack by ID.
    Returns pack instance (owned by customer) with punch count remaining, expiration date, purchase info, service restrictions, and usage history.
    Use to check pack balance, verify eligibility, or manage customer packs.
    Packs contain punches used for visits.
  DESC

  input_schema(
    properties: {
      pack_id: { type: 'integer', description: 'Unique Pike13 pack ID (integer)' }
    },
    required: ['pack_id']
  )

  class << self
    def call(pack_id:, server_context:)
      Pike13::Desk::Pack.find(pack_id).to_json
    end
  end
end

class DeskDeletePack < Pike13BaseTool
  description <<~DESC
    [STAFF] Delete (void) a pack.
    Removes the pack and refunds any unused punches.
    Use for cancellations or issuing refunds.
    WARNING: This action cannot be undone.
  DESC

  input_schema(
    properties: {
      pack_id: { type: 'integer', description: 'Unique Pike13 pack ID to delete' }
    },
    required: ['pack_id']
  )

  class << self
    def call(pack_id:, server_context:)
      Pike13::Desk::Pack.destroy(pack_id).to_json
    end
  end
end
