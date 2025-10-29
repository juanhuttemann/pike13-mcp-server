# frozen_string_literal: true

require_relative 'base_tool'

class DeskListPersonWaivers < Pike13BaseTool
  description '[STAFF] List all signed waivers for a person. Returns array of waiver objects with waiver name, signed date, IP address, status (active/expired), expiration date, and document reference. Use for liability verification, compliance checking, or customer service.'

  arguments do
    required(:person_id).filled(:integer).description('Unique Pike13 person ID (integer)')
  end

  def call(person_id:)
    Pike13::Desk::PersonWaiver.all(person_id: person_id).to_json
  end
end

class FrontListPersonWaivers < Pike13BaseTool
  description '[CLIENT] List customer own signed waivers. Returns array of customer-visible waiver objects with waiver name, signed date, and expiration. Use for customer self-service waiver viewing.'

  arguments do
    required(:person_id).filled(:integer).description('Unique Pike13 person ID (integer)')
  end

  def call(person_id:)
    Pike13::Front::PersonWaiver.all(person_id: person_id).to_json
  end
end
