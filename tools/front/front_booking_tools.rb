# frozen_string_literal: true

require_relative '../base_tool'

class FrontGetBooking < Pike13BaseTool
  description <<~DESC
    [CLIENT] Get event REGISTRATION details.
    Returns: registration status, waitlist position, payment info.
    Use for "my booking", "registration status", "waitlist position" questions.
    Bookings = registrations reserved, Visits = actual attendance completed.
  DESC

  input_schema(
    properties: {
      booking_id: { type: 'integer', description: 'Unique Pike13 booking ID (integer)' }
    },
    required: ['booking_id']
  )

  class << self
    def call(booking_id:, server_context:)
      Pike13::Front::Booking.find(booking_id).to_json
    end
  end
end

class FrontCreateBooking < Pike13BaseTool
  description <<~DESC
    [CLIENT] Create a new booking/registration for a course.
    Books/registers authenticated customer for course or appointment.
    Returns created booking with confirmation details.
    Use for course enrollments or appointment bookings.
  DESC

  input_schema(
    properties: {
      attributes: { type: 'object', description: 'Booking attributes (event_id, person_id, etc.)' }
    },
    required: ['attributes']
  )

  class << self
    def call(attributes:, server_context:)
      Pike13::Front::Booking.create(attributes).to_json
    end
  end
end

class FrontUpdateBooking < Pike13BaseTool
  description <<~DESC
    [CLIENT] Update an existing booking.
    Modifies booking details or preferences.
    Returns updated booking.
  DESC

  input_schema(
    properties: {
      booking_id: { type: 'integer', description: 'Unique Pike13 booking ID to update' },
      attributes: { type: 'object', description: 'Booking attributes to update' }
    },
    required: %w[booking_id attributes]
  )

  class << self
    def call(booking_id:, attributes:, server_context:)
      Pike13::Front::Booking.update(booking_id, attributes).to_json
    end
  end
end

class FrontDeleteBooking < Pike13BaseTool
  description <<~DESC
    [CLIENT] Cancel/delete a booking.
    Cancels the customer's course registration or appointment booking.
    Returns cancellation confirmation.
    Use when customer wants to cancel their booking.
  DESC

  input_schema(
    properties: {
      booking_id: { type: 'integer', description: 'Unique Pike13 booking ID to cancel' }
    },
    required: ['booking_id']
  )

  class << self
    def call(booking_id:, server_context:)
      Pike13::Front::Booking.destroy(booking_id).to_json
    end
  end
end

class FrontCreateBookingLease < Pike13BaseTool
  description <<~DESC
    [CLIENT] Create a booking lease.
    Creates temporary hold/lease on booking slot.
    Returns lease with expiration time.
    Use for holding a spot during checkout process.
  DESC

  input_schema(
    properties: {
      booking_id: { type: 'integer', description: 'Booking ID to create lease for' },
      attributes: { type: 'object', description: 'Lease attributes' }
    },
    required: %w[booking_id attributes]
  )

  class << self
    def call(booking_id:, attributes:, server_context:)
      Pike13::Front::Booking.create_lease(booking_id, attributes).to_json
    end
  end
end

class FrontUpdateBookingLease < Pike13BaseTool
  description <<~DESC
    [CLIENT] Update a booking lease.
    Extends or modifies the booking hold/lease.
    Returns updated lease.
  DESC

  input_schema(
    properties: {
      booking_id: { type: 'integer', description: 'Booking ID' },
      lease_id: { type: 'integer', description: 'Lease ID to update' },
      attributes: { type: 'object', description: 'Lease attributes to update' }
    },
    required: %w[booking_id lease_id attributes]
  )

  class << self
    def call(booking_id:, lease_id:, attributes:, server_context:)
      Pike13::Front::Booking.update_lease(booking_id, lease_id, attributes).to_json
    end
  end
end

class FrontDeleteBookingLease < Pike13BaseTool
  description <<~DESC
    [CLIENT] Delete a booking lease.
    Releases the temporary hold on booking slot.
    Returns confirmation.
  DESC

  input_schema(
    properties: {
      booking_id: { type: 'integer', description: 'Booking ID' },
      lease_id: { type: 'integer', description: 'Lease ID to delete' }
    },
    required: %w[booking_id lease_id]
  )

  class << self
    def call(booking_id:, lease_id:, server_context:)
      Pike13::Front::Booking.destroy_lease(booking_id, lease_id).to_json
    end
  end
end

class FrontGetBookingLease < Pike13BaseTool
  description <<~DESC
    [CLIENT] Get booking lease details. A lease temporarily holds a spot during the booking process.
    Returns lease object with expiration time, booking details, and hold status.
    Use to verify lease status during multi-step booking checkout or to display countdown timer for held spots.
  DESC

  input_schema(
    properties: {
      booking_id: { type: 'integer', description: 'Unique Pike13 booking ID (integer)' },
      lease_id: { type: 'integer', description: 'Unique booking lease ID (integer)' }
    },
    required: %w[booking_id lease_id]
  )

  class << self
    def call(booking_id:, lease_id:, server_context:)
      Pike13::Front::Booking.find_lease(booking_id: booking_id, id: lease_id).to_json
    end
  end
end
