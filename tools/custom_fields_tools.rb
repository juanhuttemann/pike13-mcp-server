# frozen_string_literal: true

require_relative 'base_tool'

class Pike13DeskListCustomFields < Pike13BaseTool
  description '[STAFF ONLY] List custom fields'

  def call
    client.desk.custom_fields.all.to_json
  end
end
