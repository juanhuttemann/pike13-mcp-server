# frozen_string_literal: true

require_relative 'base_tool'

class DeskListCustomFields < Pike13BaseTool
  description <<~DESC
    [STAFF ONLY] List custom profile field definitions.
    Returns custom field configurations with names, types (text, dropdown, checkbox), options, required status, and visibility.
    Use to understand additional data collected on person profiles beyond standard fields (e.g., emergency contacts, preferences, medical info).
  DESC

  class << self
    def call(server_context:)
      Pike13::Desk::CustomField.all.to_json
    end
  end
end
