# frozen_string_literal: true

require_relative 'base_tool'

# Front (CLIENT) Booking Tools

class FrontGetBooking < Pike13BaseTool
  description <<~DESC
    [CLIENT] Get event REGISTRATION details.
    Returns: registration status, waitlist position, payment info.
    Use for "my booking", "registration status", "waitlist position" questions.
    Bookings = registrations reserved, Visits = actual attendance completed.
  DESC

  arguments do
    required(:booking_id).filled(:integer).description('Unique Pike13 booking ID (integer)')
  end

  def call(booking_id:)
    Pike13::Front::Booking.find(booking_id).to_json
  end
end

class FrontCreateBooking < Pike13BaseTool
  description <<~DESC
    [CLIENT] Create a new booking/registration for a course.
    Books/registers authenticated customer for course or appointment.
    Returns created booking with confirmation details.
    Use for course enrollments or appointment bookings.
  DESC

  arguments do
    required(:attributes).filled(:hash).description('Booking attributes (event_id, person_id, etc.)')
  end

  def call(attributes:)
    Pike13::Front::Booking.create(attributes).to_json
  end
end

class FrontUpdateBooking < Pike13BaseTool
  description <<~DESC
    [CLIENT] Update an existing booking.
    Modifies booking details or preferences.
    Returns updated booking.
  DESC

  arguments do
    required(:booking_id).filled(:integer).description('Unique Pike13 booking ID to update')
    required(:attributes).filled(:hash).description('Booking attributes to update')
  end

  def call(booking_id:, attributes:)
    Pike13::Front::Booking.update(booking_id, attributes).to_json
  end
end

class FrontDeleteBooking < Pike13BaseTool
  description <<~DESC
    [CLIENT] Cancel/delete a booking.
    Cancels the customer's course registration or appointment booking.
    Returns cancellation confirmation.
    Use when customer wants to cancel their booking.
  DESC

  arguments do
    required(:booking_id).filled(:integer).description('Unique Pike13 booking ID to cancel')
  end

  def call(booking_id:)
    Pike13::Front::Booking.destroy(booking_id).to_json
  end
end

class FrontCreateBookingLease < Pike13BaseTool
  description <<~DESC
    [CLIENT] Create a booking lease.
    Creates temporary hold/lease on booking slot.
    Returns lease with expiration time.
    Use for holding a spot during checkout process.
  DESC

  arguments do
    required(:booking_id).filled(:integer).description('Booking ID to create lease for')
    required(:attributes).filled(:hash).description('Lease attributes')
  end

  def call(booking_id:, attributes:)
    Pike13::Front::Booking.create_lease(booking_id, attributes).to_json
  end
end

class FrontUpdateBookingLease < Pike13BaseTool
  description <<~DESC
    [CLIENT] Update a booking lease.
    Extends or modifies the booking hold/lease.
    Returns updated lease.
  DESC

  arguments do
    required(:booking_id).filled(:integer).description('Booking ID')
    required(:lease_id).filled(:integer).description('Lease ID to update')
    required(:attributes).filled(:hash).description('Lease attributes to update')
  end

  def call(booking_id:, lease_id:, attributes:)
    Pike13::Front::Booking.update_lease(booking_id, lease_id, attributes).to_json
  end
end

class FrontDeleteBookingLease < Pike13BaseTool
  description <<~DESC
    [CLIENT] Delete a booking lease.
    Releases the temporary hold on booking slot.
    Returns confirmation.
  DESC

  arguments do
    required(:booking_id).filled(:integer).description('Booking ID')
    required(:lease_id).filled(:integer).description('Lease ID to delete')
  end

  def call(booking_id:, lease_id:)
    Pike13::Front::Booking.destroy_lease(booking_id, lease_id).to_json
  end
end

# Desk (STAFF) Booking Tools

class DeskGetBooking < Pike13BaseTool
  description <<~DESC
    [STAFF] Get event registration details by ID.
    Returns complete booking with customer, event occurrence, registration time, payment status, cancellation status, and modifications.
    Use for registration management or resolving booking issues.
    Bookings are reservations for events.
  DESC

  arguments do
    required(:booking_id).filled(:integer).description('Unique Pike13 booking ID (integer)')
  end

  def call(booking_id:)
    Pike13::Desk::Booking.find(booking_id).to_json
  end
end

class DeskCreateBooking < Pike13BaseTool
  description <<~DESC
    [STAFF] Create a new booking/registration for a course.
    Books/registers specified person for course or appointment.
    Returns created booking with confirmation details.
    Use for manual course enrollments or appointment bookings.
  DESC

  arguments do
    required(:attributes).filled(:hash).description('Booking attributes (event_id, person_id, etc.)')
  end

  def call(attributes:)
    Pike13::Desk::Booking.create(attributes).to_json
  end
end

class DeskUpdateBooking < Pike13BaseTool
  description <<~DESC
    [STAFF] Update an existing booking.
    Modifies booking details, status, or preferences.
    Returns updated booking.
    Use for administrative corrections or status changes.
  DESC

  arguments do
    required(:booking_id).filled(:integer).description('Unique Pike13 booking ID to update')
    required(:attributes).filled(:hash).description('Booking attributes to update')
  end

  def call(booking_id:, attributes:)
    Pike13::Desk::Booking.update(booking_id, attributes).to_json
  end
end

class DeskDeleteBooking < Pike13BaseTool
  description <<~DESC
    [STAFF] Cancel/delete a booking.
    Cancels the person's course registration or appointment booking.
    Returns cancellation confirmation.
    Use for administrative cancellations or customer service.
  DESC

  arguments do
    required(:booking_id).filled(:integer).description('Unique Pike13 booking ID to cancel')
  end

  def call(booking_id:)
    Pike13::Desk::Booking.destroy(booking_id).to_json
  end
end

class DeskCreateBookingLease < Pike13BaseTool
  description <<~DESC
    [STAFF] Create a booking lease.
    Creates temporary hold/lease on booking slot.
    Returns lease with expiration time.
    Use for reserving spots during registration process.
  DESC

  arguments do
    required(:booking_id).filled(:integer).description('Booking ID to create lease for')
    required(:attributes).filled(:hash).description('Lease attributes')
  end

  def call(booking_id:, attributes:)
    Pike13::Desk::Booking.create_lease(booking_id, attributes).to_json
  end
end

class DeskUpdateBookingLease < Pike13BaseTool
  description <<~DESC
    [STAFF] Update a booking lease.
    Extends or modifies the booking hold/lease.
    Returns updated lease.
  DESC

  arguments do
    required(:booking_id).filled(:integer).description('Booking ID')
    required(:lease_id).filled(:integer).description('Lease ID to update')
    required(:attributes).filled(:hash).description('Lease attributes to update')
  end

  def call(booking_id:, lease_id:, attributes:)
    Pike13::Desk::Booking.update_lease(booking_id, lease_id, attributes).to_json
  end
end
