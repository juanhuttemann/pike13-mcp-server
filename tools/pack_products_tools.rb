# frozen_string_literal: true

require_relative 'base_tool'

class DeskListPackProducts < Pike13BaseTool
  description '[STAFF ONLY] List purchasable class pack products. Returns pack products (multi-visit bundles) with punch count, pricing, expiration rules, service restrictions, and visibility. Use for pack configuration, sales operations, or understanding available pack offerings. Packs are purchased by clients to use for multiple visits.'

  def call
    client.desk.pack_products.all.to_json
  end
end
