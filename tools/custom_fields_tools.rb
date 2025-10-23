# frozen_string_literal: true

require_relative 'base_tool'

class Pike13DeskListCustomFields < Pike13BaseTool
  description '[STAFF ONLY] List custom profile field definitions. Returns custom field configurations with names, types (text, dropdown, checkbox), options, required status, and visibility. Use to understand additional data collected on person profiles beyond standard fields (e.g., emergency contacts, preferences, medical info).'

  def call
    client.desk.custom_fields.all.to_json
  end
end
