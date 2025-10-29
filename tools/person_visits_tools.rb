# frozen_string_literal: true

require_relative 'base_tool'

class DeskListPersonVisits < Pike13BaseTool
  description '[STAFF] List all visits (attendance records) for a person. Returns array of visit objects with event details, check-in/out times, visit status, payment info, and credits used. Use for attendance history, billing verification, or customer activity tracking.'

  arguments do
    required(:person_id).filled(:integer).description('Unique Pike13 person ID (integer)')
  end

  def call(person_id:)
    Pike13::Desk::PersonVisit.all(person_id: person_id).to_json
  end
end

class FrontListPersonVisits < Pike13BaseTool
  description '[CLIENT] List customer own visit history. Returns array of customer-visible visit objects with class details, dates, and attendance status. Use for customer self-service attendance viewing.'

  arguments do
    required(:person_id).filled(:integer).description('Unique Pike13 person ID (integer)')
  end

  def call(person_id:)
    Pike13::Front::PersonVisit.all(person_id: person_id).to_json
  end
end
