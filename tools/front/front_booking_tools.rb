# frozen_string_literal: true

require_relative '../base_tool'

class FrontGetBooking < Pike13BaseTool
  description "Get booking details"

  input_schema(
    properties: {
      booking_id: { type: 'integer', description: 'Booking ID' }
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
  description "Create booking."

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
  description "Update booking."

  input_schema(
    properties: {
      booking_id: { type: 'integer', description: 'Booking ID' },
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
  description "Delete booking"

  input_schema(
    properties: {
      booking_id: { type: 'integer', description: 'Booking ID' }
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
  description "Create booking lease"

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
  description "Update booking lease"

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
  description "Delete booking lease"

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
  description "Get booking lease"

  input_schema(
    properties: {
      booking_id: { type: 'integer', description: 'Booking ID' },
      lease_id: { type: 'integer', description: 'Lease ID' }
    },
    required: %w[booking_id lease_id]
  )

  class << self
    def call(booking_id:, lease_id:, server_context:)
      Pike13::Front::Booking.find_lease(booking_id: booking_id, id: lease_id).to_json
    end
  end
end
