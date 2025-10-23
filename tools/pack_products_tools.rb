# frozen_string_literal: true

require_relative 'base_tool'

class Pike13DeskListPackProducts < Pike13BaseTool
  description '[STAFF ONLY] List pack products'

  def call
    client.desk.pack_products.all.to_json
  end
end
