# frozen_string_literal: true

require_relative 'base_tool'

class Pike13FrontGetBooking < Pike13BaseTool
  description '[CLIENT] Get customer event registration by ID. Returns booking (reservation for event occurrence) with registration status, waitlist position, payment info, and cancellation terms. Use to show booking confirmation or status. Bookings are reservations, visits are actual attendance.'

  arguments do
    required(:booking_id).filled(:integer).description('Unique Pike13 booking ID (integer)')
  end

  def call(booking_id:)
    client.front.bookings.find(booking_id).to_json
  end
end

class Pike13DeskGetBooking < Pike13BaseTool
  description '[STAFF] Get event registration details by ID. Returns complete booking with customer, event occurrence, registration time, payment status, cancellation status, and modifications. Use for registration management or resolving booking issues. Bookings are reservations for events.'

  arguments do
    required(:booking_id).filled(:integer).description('Unique Pike13 booking ID (integer)')
  end

  def call(booking_id:)
    client.desk.bookings.find(booking_id).to_json
  end
end
