# frozen_string_literal: true

require_relative 'base_tool'

class Pike13FrontListAppointments < Pike13BaseTool
  description '[CLIENT] List my appointments'

  def call
    client.front.appointments.all.to_json
  end
end

class Pike13FrontGetAppointment < Pike13BaseTool
  description '[CLIENT] Get appointment by ID'

  arguments do
    required(:appointment_id).filled(:integer).description('Appointment ID')
  end

  def call(appointment_id:)
    client.front.appointments.find(appointment_id).to_json
  end
end

class Pike13DeskListAppointments < Pike13BaseTool
  description '[STAFF] List all appointments'

  def call
    client.desk.appointments.all.to_json
  end
end

class Pike13DeskGetAppointment < Pike13BaseTool
  description '[STAFF] Get appointment by ID'

  arguments do
    required(:appointment_id).filled(:integer).description('Appointment ID')
  end

  def call(appointment_id:)
    client.desk.appointments.find(appointment_id).to_json
  end
end
