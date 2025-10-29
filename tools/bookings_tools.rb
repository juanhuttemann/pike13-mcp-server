# frozen_string_literal: true

require_relative 'base_tool'

class FrontGetBooking < Pike13BaseTool
  description '[CLIENT] Get event REGISTRATION details. Returns: registration status, waitlist position, payment info. Use for "my booking", "registration status", "waitlist position" questions. Bookings = registrations reserved, Visits = actual attendance completed.'

  arguments do
    required(:booking_id).filled(:integer).description('Unique Pike13 booking ID (integer)')
  end

  def call(booking_id:)
    Pike13::Front::Booking.find(booking_id).to_json
  end
end

class DeskGetBooking < Pike13BaseTool
  description '[STAFF] Get event registration details by ID. Returns complete booking with customer, event occurrence, registration time, payment status, cancellation status, and modifications. Use for registration management or resolving booking issues. Bookings are reservations for events.'

  arguments do
    required(:booking_id).filled(:integer).description('Unique Pike13 booking ID (integer)')
  end

  def call(booking_id:)
    Pike13::Desk::Booking.find(booking_id).to_json
  end
end
