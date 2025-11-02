# frozen_string_literal: true

require_relative "../base_tool"

class DeskListPackProducts < Pike13BaseTool
  description <<~DESC
    [STAFF ONLY] List purchasable class pack products.
    Returns pack products (multi-visit bundles) with punch count, pricing, expiration rules, service restrictions, and visibility.
    Use for pack configuration, sales operations, or understanding available pack offerings.
    Packs are purchased by clients to use for multiple visits.
  DESC

  class << self
    def call(server_context:)
      Pike13::Desk::PackProduct.all.to_json
    end
  end
end

class DeskGetPackProduct < Pike13BaseTool
  description <<~DESC
    [STAFF] Get specific pack product by ID.
    Returns complete pack product details including punch count, pricing, expiration settings, service restrictions, and purchase limits.
    Use for reviewing pack configuration or customer inquiries.
  DESC

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
  description <<~DESC
    [STAFF] Create a new pack product.
    Creates a new multi-visit pack product with specified punch count, pricing, and expiration rules.
    Returns created pack product with ID.
    Use for setting up new pack offerings.
  DESC

  input_schema(
    properties: {
      name: { type: 'string', description: 'Pack product name' },
      count: { type: 'integer', description: 'Number of punches/visits in pack' },
      price_cents: { type: 'integer', description: 'Pack price in cents' },
      additional_attributes: { type: 'object', description: 'Optional: Additional attributes (expiration_days, service_ids, etc.)' }
    },
    required: ['name', 'count', 'price_cents']
  )

  class << self
    def call(name:, count:, price_cents:, additional_attributes: nil, server_context:)
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
  description <<~DESC
    [STAFF] Update an existing pack product.
    Modifies pack product details like name, pricing, or expiration settings.
    Returns updated pack product.
    Use for updating pack configurations.
  DESC

  input_schema(
    properties: {
      pack_product_id: { type: 'integer', description: 'Unique Pike13 pack product ID to update' },
      attributes: { type: 'object', description: 'Pack product attributes to update' }
    },
    required: ['pack_product_id', 'attributes']
  )

  class << self
    def call(pack_product_id:, attributes:, server_context:)
      Pike13::Desk::PackProduct.update(pack_product_id, attributes).to_json
    end
  end
end

class DeskDeletePackProduct < Pike13BaseTool
  description <<~DESC
    [STAFF] Delete (archive) a pack product.
    Archives the pack product so it's no longer available for purchase.
    Existing purchased packs are not affected.
    Returns confirmation.
  DESC

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
  description <<~DESC
    [STAFF] Create a pack instance for a person from a pack product.
    Issues/sells a pack to a specific person based on the pack product template.
    Returns created pack with remaining punches.
    Use for selling packs to customers or issuing complimentary packs.
  DESC

  input_schema(
    properties: {
      pack_product_id: { type: 'integer', description: 'Pack product ID to create pack from' },
      person_id: { type: 'integer', description: 'Person ID to assign pack to' },
      additional_attributes: { type: 'object', description: 'Optional: Additional pack attributes (price_cents override, expiration_date, etc.)' }
    },
    required: ['pack_product_id', 'person_id']
  )

  class << self
    def call(pack_product_id:, person_id:, additional_attributes: nil, server_context:)
      attributes = { person_id: person_id }
      attributes.merge!(additional_attributes) if additional_attributes

      Pike13::Desk::PackProduct.create_pack(pack_product_id, attributes).to_json
    end
  end
end
