# frozen_string_literal: true

require_relative 'base_tool'

class DeskListPackProducts < Pike13BaseTool
  description <<~DESC
    [STAFF ONLY] List purchasable class pack products.
    Returns pack products (multi-visit bundles) with punch count, pricing, expiration rules, service restrictions, and visibility.
    Use for pack configuration, sales operations, or understanding available pack offerings.
    Packs are purchased by clients to use for multiple visits.
  DESC

  def call
    Pike13::Desk::PackProduct.all.to_json
  end
end

class DeskGetPackProduct < Pike13BaseTool
  description <<~DESC
    [STAFF] Get specific pack product by ID.
    Returns complete pack product details including punch count, pricing, expiration settings, service restrictions, and purchase limits.
    Use for reviewing pack configuration or customer inquiries.
  DESC

  arguments do
    required(:pack_product_id).filled(:integer).description('Unique Pike13 pack product ID')
  end

  def call(pack_product_id:)
    Pike13::Desk::PackProduct.find(pack_product_id).to_json
  end
end

class DeskCreatePackProduct < Pike13BaseTool
  description <<~DESC
    [STAFF] Create a new pack product.
    Creates a new multi-visit pack product with specified punch count, pricing, and expiration rules.
    Returns created pack product with ID.
    Use for setting up new pack offerings.
  DESC

  arguments do
    required(:name).filled(:string).description('Pack product name')
    required(:count).filled(:integer).description('Number of punches/visits in pack')
    required(:price_cents).filled(:integer).description('Pack price in cents')
    optional(:additional_attributes).maybe(:hash).description('Optional: Additional attributes (expiration_days, service_ids, etc.)')
  end

  def call(name:, count:, price_cents:, additional_attributes: nil)
    attributes = {
      name: name,
      count: count,
      price_cents: price_cents
    }
    attributes.merge!(additional_attributes) if additional_attributes

    Pike13::Desk::PackProduct.create(attributes).to_json
  end
end

class DeskUpdatePackProduct < Pike13BaseTool
  description <<~DESC
    [STAFF] Update an existing pack product.
    Modifies pack product details like name, pricing, or expiration settings.
    Returns updated pack product.
    Use for updating pack configurations.
  DESC

  arguments do
    required(:pack_product_id).filled(:integer).description('Unique Pike13 pack product ID to update')
    required(:attributes).filled(:hash).description('Pack product attributes to update')
  end

  def call(pack_product_id:, attributes:)
    Pike13::Desk::PackProduct.update(pack_product_id, attributes).to_json
  end
end

class DeskDeletePackProduct < Pike13BaseTool
  description <<~DESC
    [STAFF] Delete (archive) a pack product.
    Archives the pack product so it's no longer available for purchase.
    Existing purchased packs are not affected.
    Returns confirmation.
  DESC

  arguments do
    required(:pack_product_id).filled(:integer).description('Unique Pike13 pack product ID to delete')
  end

  def call(pack_product_id:)
    Pike13::Desk::PackProduct.destroy(pack_product_id).to_json
  end
end

class DeskCreatePackFromProduct < Pike13BaseTool
  description <<~DESC
    [STAFF] Create a pack instance for a person from a pack product.
    Issues/sells a pack to a specific person based on the pack product template.
    Returns created pack with remaining punches.
    Use for selling packs to customers or issuing complimentary packs.
  DESC

  arguments do
    required(:pack_product_id).filled(:integer).description('Pack product ID to create pack from')
    required(:person_id).filled(:integer).description('Person ID to assign pack to')
    optional(:additional_attributes).maybe(:hash).description('Optional: Additional pack attributes (price_cents override, expiration_date, etc.)')
  end

  def call(pack_product_id:, person_id:, additional_attributes: nil)
    attributes = { person_id: person_id }
    attributes.merge!(additional_attributes) if additional_attributes

    Pike13::Desk::PackProduct.create_pack(pack_product_id, attributes).to_json
  end
end
