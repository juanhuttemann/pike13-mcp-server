# frozen_string_literal: true

require_relative '../base_tool'

class DeskListPackProducts < Pike13BaseTool
  description "List pack products"

  class << self
    def call(server_context:)
      Pike13::Desk::PackProduct.all.to_json
    end
  end
end

class DeskGetPackProduct < Pike13BaseTool
  description "Get pack product"

  input_schema(
    properties: {
      pack_product_id: { type: 'integer', description: 'Unique Pike13 pack product ID' }
    },
    required: ['pack_product_id']
  )

  class << self
    def call(pack_product_id:, server_context:)
      Pike13::Desk::PackProduct.find(pack_product_id).to_json
    end
  end
end

class DeskCreatePackProduct < Pike13BaseTool
  description "Create pack product"

  input_schema(
    properties: {
      name: { type: 'string', description: 'Pack product name' },
      count: { type: 'integer', description: 'Number of punches/visits in pack' },
      price_cents: { type: 'integer', description: 'Pack price in cents' },
      additional_attributes: { type: 'object',
                               description: 'Optional: Additional attributes (expiration_days, service_ids, etc.)' }
    },
    required: %w[name count price_cents]
  )

  class << self
    def call(name:, count:, price_cents:, server_context:, additional_attributes: nil)
      attributes = {
        name: name,
        count: count,
        price_cents: price_cents
      }
      attributes.merge!(additional_attributes) if additional_attributes

      Pike13::Desk::PackProduct.create(attributes).to_json
    end
  end
end

class DeskUpdatePackProduct < Pike13BaseTool
  description "Update pack product"

  input_schema(
    properties: {
      pack_product_id: { type: 'integer', description: 'Unique Pike13 pack product ID to update' },
      attributes: { type: 'object', description: 'Pack product attributes to update' }
    },
    required: %w[pack_product_id attributes]
  )

  class << self
    def call(pack_product_id:, attributes:, server_context:)
      Pike13::Desk::PackProduct.update(pack_product_id, attributes).to_json
    end
  end
end

class DeskDeletePackProduct < Pike13BaseTool
  description "Delete pack product"

  input_schema(
    properties: {
      pack_product_id: { type: 'integer', description: 'Unique Pike13 pack product ID to delete' }
    },
    required: ['pack_product_id']
  )

  class << self
    def call(pack_product_id:, server_context:)
      Pike13::Desk::PackProduct.destroy(pack_product_id).to_json
    end
  end
end

class DeskCreatePackFromProduct < Pike13BaseTool
  description "Create pack for person"

  input_schema(
    properties: {
      pack_product_id: { type: 'integer', description: 'Pack product ID to create pack from' },
      person_id: { type: 'integer', description: 'Person ID to assign pack to' },
      additional_attributes: { type: 'object',
                               description: 'Optional: Additional pack attributes (price_cents override, expiration_date, etc.)' }
    },
    required: %w[pack_product_id person_id]
  )

  class << self
    def call(pack_product_id:, person_id:, server_context:, additional_attributes: nil)
      attributes = { person_id: person_id }
      attributes.merge!(additional_attributes) if additional_attributes

      Pike13::Desk::PackProduct.create_pack(pack_product_id, attributes).to_json
    end
  end
end
