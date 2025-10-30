# frozen_string_literal: true

require_relative 'base_tool'

class FrontListEventOccurrences < Pike13BaseTool
  description <<~DESC
    [CLIENT] STEP 2: List ACTUAL scheduled classes/times (not templates).
    Returns: Monday 9am Yoga, Tuesday 6pm Pilates, etc.
    Use AFTER FrontListEvents to get specific times for booking.
    Workflow: FrontListEvents → FrontListEventOccurrences → FrontCreateVisit to book.
  DESC

  arguments do
    required(:from).filled(:string).description('Start date in YYYY-MM-DD format (e.g., "2025-01-15")')
    required(:to).filled(:string).description('End date in YYYY-MM-DD format (e.g., "2025-01-22")')
  end

  def call(from:, to:)
    Pike13::Front::EventOccurrence.all(from: from, to: to).to_json
  end
end

class FrontGetEventOccurrence < Pike13BaseTool
  description <<~DESC
    [CLIENT] Get specific scheduled class instance by ID.
    Returns occurrence with exact time, instructor, location, capacity, spots remaining, and current registrations.
    Use to show class details before booking or to check availability.
  DESC

  arguments do
    required(:occurrence_id).filled(:integer).description('Unique Pike13 event occurrence ID (integer)')
  end

  def call(occurrence_id:)
    Pike13::Front::EventOccurrence.find(occurrence_id).to_json
  end
end

class DeskListEventOccurrences < Pike13BaseTool
  description <<~DESC
    [STAFF] List scheduled class instances with admin data for date range.
    Returns occurrences with attendance, registrations, revenue, instructor assignments, and status.
    Use for staff schedule view, attendance tracking, or reporting.
    Required for most schedule operations.
  DESC

  arguments do
    required(:from).filled(:string).description('Start date in YYYY-MM-DD format (e.g., "2025-01-15")')
    required(:to).filled(:string).description('End date in YYYY-MM-DD format (e.g., "2025-01-22")')
  end

  def call(from:, to:)
    Pike13::Desk::EventOccurrence.all(from: from, to: to).to_json
  end
end

class DeskGetEventOccurrence < Pike13BaseTool
  description <<~DESC
    [STAFF] Get complete scheduled class instance by ID.
    Returns full occurrence data: roster, attendance, revenue, notes, instructor, location, and all admin details.
    Use for attendance management, roster viewing, or occurrence-specific reporting.
  DESC

  arguments do
    required(:occurrence_id).filled(:integer).description('Unique Pike13 event occurrence ID (integer)')
  end

  def call(occurrence_id:)
    Pike13::Desk::EventOccurrence.find(occurrence_id).to_json
  end
end

class FrontGetEventOccurrencesSummary < Pike13BaseTool
  description <<~DESC
    [CLIENT] Get event occurrences summary for date range.
    Returns aggregated summary of scheduled classes by day.
    Use for calendar views or availability overviews for customers.
  DESC

  arguments do
    required(:from).filled(:string).description('Start date in YYYY-MM-DD format')
    required(:to).filled(:string).description('End date in YYYY-MM-DD format')
    optional(:additional_params).maybe(:hash).description('Optional: Additional filter parameters')
  end

  def call(from:, to:, additional_params: nil)
    params = { from: from, to: to }
    params.merge!(additional_params) if additional_params

    Pike13::Front::EventOccurrence.summary(**params).to_json
  end
end

class FrontGetEventOccurrenceEnrollmentEligibilities < Pike13BaseTool
  description <<~DESC
    [CLIENT] Check enrollment eligibility for an event occurrence.
    Returns eligibility status and restrictions for authenticated customer and dependents.
    Use before booking to check if customer can enroll and display appropriate warnings.
  DESC

  arguments do
    required(:occurrence_id).filled(:integer).description('Event occurrence ID to check eligibility for')
    optional(:additional_params).maybe(:hash).description('Optional: Additional parameters')
  end

  def call(occurrence_id:, additional_params: nil)
    params = additional_params || {}
    Pike13::Front::EventOccurrence.enrollment_eligibilities(id: occurrence_id, **params).to_json
  end
end

class DeskGetEventOccurrencesSummary < Pike13BaseTool
  description <<~DESC
    [STAFF] Get event occurrences summary for date range with admin data.
    Returns aggregated summary of scheduled classes by day with attendance and revenue stats.
    Use for reporting, dashboard views, or schedule analysis.
  DESC

  arguments do
    required(:from).filled(:string).description('Start date in YYYY-MM-DD format')
    required(:to).filled(:string).description('End date in YYYY-MM-DD format')
    optional(:additional_params).maybe(:hash).description('Optional: Additional filter parameters')
  end

  def call(from:, to:, additional_params: nil)
    params = { from: from, to: to }
    params.merge!(additional_params) if additional_params

    Pike13::Desk::EventOccurrence.summary(**params).to_json
  end
end

class DeskGetEventOccurrenceEnrollmentEligibilities < Pike13BaseTool
  description <<~DESC
    [STAFF] Check enrollment eligibility for specific people in an event occurrence.
    Returns eligibility status and restrictions for specified person IDs.
    Use before enrolling people to verify they can join the class.
  DESC

  arguments do
    required(:occurrence_id).filled(:integer).description('Event occurrence ID to check eligibility for')
    optional(:person_ids).maybe(:string).description('Optional: Comma-delimited person IDs to check')
    optional(:additional_params).maybe(:hash).description('Optional: Additional parameters')
  end

  def call(occurrence_id:, person_ids: nil, additional_params: nil)
    params = additional_params || {}
    params[:person_ids] = person_ids if person_ids

    Pike13::Desk::EventOccurrence.enrollment_eligibilities(id: occurrence_id, **params).to_json
  end
end
