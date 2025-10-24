# frozen_string_literal: true

require_relative 'base_tool'

class FrontListVisits < Pike13BaseTool
  description '[CLIENT] List authenticated customer attendance records. Returns visits (attendance at events or appointments) with date, service, instructor, status (completed/missed/late), and usage from passes. Use to show customer their attendance history.'

  def call
    client.front.visits.all.to_json
  end
end

class FrontGetVisit < Pike13BaseTool
  description '[CLIENT] Get customer visit (attendance record) by ID. Returns visit details: event/appointment attended, date/time, instructor, check-in status, payment method used. Use to show specific attendance details to customer.'

  arguments do
    required(:visit_id).filled(:integer).description('Unique Pike13 visit ID (integer)')
  end

  def call(visit_id:)
    client.front.visits.find(visit_id).to_json
  end
end

class DeskListVisits < Pike13BaseTool
  description '[STAFF] List attendance records with optional person filter. Returns visits with client, event/appointment, time, status, payment, and punch usage. Use for attendance tracking, reporting, or viewing person history. Visits are attendance records, not bookings.'

  arguments do
    optional(:person_id).maybe(:integer).description('Optional: filter visits for specific person (integer person_id)')
  end

  def call(person_id: nil)
    visits = person_id ? client.desk.visits.all(person_id: person_id) : client.desk.visits.all
    visits.to_json
  end
end

class DeskGetVisit < Pike13BaseTool
  description '[STAFF] Get complete visit (attendance) record by ID. Returns full visit data: person, event/appointment, check-in time, status, payment method, punch used, notes, and modifications. Use for attendance verification or dispute resolution.'

  arguments do
    required(:visit_id).filled(:integer).description('Unique Pike13 visit ID (integer)')
  end

  def call(visit_id:)
    client.desk.visits.find(visit_id).to_json
  end
end
