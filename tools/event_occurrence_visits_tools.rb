# frozen_string_literal: true

require_relative 'base_tool'

class DeskListEventOccurrenceVisits < Pike13BaseTool
  description <<~DESC
    [STAFF] List all visits (attendance records) for an event occurrence (class session).
    Returns array of visit objects with person details, check-in time, check-out time, visit status, and payment info.
    Use for attendance tracking, roster viewing, or session reporting.
  DESC

  arguments do
    required(:event_occurrence_id).filled(:integer).description('Unique Pike13 event occurrence ID (integer)')
  end

  def call(event_occurrence_id:)
    Pike13::Desk::EventOccurrenceVisit.all(event_occurrence_id: event_occurrence_id).to_json
  end
end
