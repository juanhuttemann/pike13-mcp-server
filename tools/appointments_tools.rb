# frozen_string_literal: true

require_relative 'base_tool'

class Pike13FrontListAppointments < Pike13BaseTool
  description '[CLIENT] List authenticated customer appointments. Returns user appointments with time, service, staff member, location, and status. Use for showing customer their upcoming/past one-on-one sessions. Different from events: appointments are 1:1 scheduled services, not group classes.'

  def call
    client.front.appointments.all.to_json
  end
end

class Pike13FrontGetAppointment < Pike13BaseTool
  description '[CLIENT] Get customer appointment details by ID. Returns appointment with exact time, service, practitioner, location, notes, and booking status. Use to show appointment details or confirm bookings. Only returns appointments for authenticated user.'

  arguments do
    required(:appointment_id).filled(:integer).description('Unique Pike13 appointment ID (integer)')
  end

  def call(appointment_id:)
    client.front.appointments.find(appointment_id).to_json
  end
end

class Pike13DeskListAppointments < Pike13BaseTool
  description '[STAFF] List all appointments across business. Returns appointments with client, staff, time, service, revenue, and status. Use for staff schedule management, appointment tracking, or reporting. Different from events: appointments are 1:1 sessions.'

  def call
    client.desk.appointments.all.to_json
  end
end

class Pike13DeskGetAppointment < Pike13BaseTool
  description '[STAFF] Get complete appointment details by ID. Returns full appointment data: client, staff, service, time, pricing, payment status, notes, and history. Use for appointment management, client records, or administrative operations.'

  arguments do
    required(:appointment_id).filled(:integer).description('Unique Pike13 appointment ID (integer)')
  end

  def call(appointment_id:)
    client.desk.appointments.find(appointment_id).to_json
  end
end
