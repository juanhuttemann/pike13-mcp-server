# frozen_string_literal: true

require_relative 'base_tool'

class Pike13FrontGetBooking < Pike13BaseTool
  description '[CLIENT] Get booking by ID'

  arguments do
    required(:booking_id).filled(:integer).description('Booking ID')
  end

  def call(booking_id:)
    client.front.bookings.find(booking_id).to_json
  end
end

class Pike13DeskGetBooking < Pike13BaseTool
  description '[STAFF] Get booking by ID'

  arguments do
    required(:booking_id).filled(:integer).description('Booking ID')
  end

  def call(booking_id:)
    client.desk.bookings.find(booking_id).to_json
  end
end
