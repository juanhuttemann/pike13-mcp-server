# frozen_string_literal: true

require_relative 'base_tool'

class FrontGetBookingLease < Pike13BaseTool
  description <<~DESC
    [CLIENT] Get booking lease details. A lease temporarily holds a spot during the booking process.
    Returns lease object with expiration time, booking details, and hold status.
    Use to verify lease status during multi-step booking checkout or to display countdown timer for held spots.
  DESC

  arguments do
    required(:booking_id).filled(:integer).description('Unique Pike13 booking ID (integer)')
    required(:lease_id).filled(:integer).description('Unique booking lease ID (integer)')
  end

  def call(booking_id:, lease_id:)
    Pike13::Front::Booking.find_lease(booking_id: booking_id, id: lease_id).to_json
  end
end
