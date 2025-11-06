# frozen_string_literal: true

require_relative '../base_tool'

class DeskListPacks < Pike13BaseTool
  description "List packs"

  class << self
    def call(server_context:)
      Pike13::Desk::Pack.all.to_json
    end
  end
end

class DeskGetPack < Pike13BaseTool
  description "Get pack"

  input_schema(
    properties: {
      pack_id: { type: 'integer', description: 'Pack ID' }
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
  description "Delete pack"

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
