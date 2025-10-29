# frozen_string_literal: true

require_relative 'base_tool'

class FrontListEventOccurrences < Pike13BaseTool
  description '[CLIENT] STEP 2: List ACTUAL scheduled classes/times (not templates). Returns: Monday 9am Yoga, Tuesday 6pm Pilates, etc. Use AFTER FrontListEvents to get specific times for booking. Workflow: FrontListEvents → FrontListEventOccurrences → FrontCreateVisit to book.'

  arguments do
    required(:from).filled(:string).description('Start date in YYYY-MM-DD format (e.g., "2025-01-15")')
    required(:to).filled(:string).description('End date in YYYY-MM-DD format (e.g., "2025-01-22")')
  end

  def call(from:, to:)
    Pike13::Front::EventOccurrence.all(from: from, to: to).to_json
  end
end

class FrontGetEventOccurrence < Pike13BaseTool
  description '[CLIENT] Get specific scheduled class instance by ID. Returns occurrence with exact time, instructor, location, capacity, spots remaining, and current registrations. Use to show class details before booking or to check availability.'

  arguments do
    required(:occurrence_id).filled(:integer).description('Unique Pike13 event occurrence ID (integer)')
  end

  def call(occurrence_id:)
    Pike13::Front::EventOccurrence.find(occurrence_id).to_json
  end
end

class DeskListEventOccurrences < Pike13BaseTool
  description '[STAFF] List scheduled class instances with admin data for date range. Returns occurrences with attendance, registrations, revenue, instructor assignments, and status. Use for staff schedule view, attendance tracking, or reporting. Required for most schedule operations.'

  arguments do
    required(:from).filled(:string).description('Start date in YYYY-MM-DD format (e.g., "2025-01-15")')
    required(:to).filled(:string).description('End date in YYYY-MM-DD format (e.g., "2025-01-22")')
  end

  def call(from:, to:)
    Pike13::Desk::EventOccurrence.all(from: from, to: to).to_json
  end
end

class DeskGetEventOccurrence < Pike13BaseTool
  description '[STAFF] Get complete scheduled class instance by ID. Returns full occurrence data: roster, attendance, revenue, notes, instructor, location, and all admin details. Use for attendance management, roster viewing, or occurrence-specific reporting.'

  arguments do
    required(:occurrence_id).filled(:integer).description('Unique Pike13 event occurrence ID (integer)')
  end

  def call(occurrence_id:)
    Pike13::Desk::EventOccurrence.find(occurrence_id).to_json
  end
end
