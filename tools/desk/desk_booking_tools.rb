# frozen_string_literal: true

require_relative '../base_tool'

class DeskGetBooking < Pike13BaseTool
  description "Get booking"

  input_schema(
    properties: {
      booking_id: { type: 'integer', description: 'Booking ID' }
    },
    required: ['booking_id']
  )

  class << self
    def call(booking_id:, server_context:)
      Pike13::Desk::Booking.find(booking_id).to_json
    end
  end
end

class DeskCreateBooking < Pike13BaseTool
  description "Create booking"

  input_schema(
    properties: {
      attributes: { type: 'object', description: 'Booking attributes (event_id, person_id, etc.)' }
    },
    required: ['attributes']
  )

  class << self
    def call(attributes:, server_context:)
      Pike13::Desk::Booking.create(attributes).to_json
    end
  end
end

class DeskUpdateBooking < Pike13BaseTool
  description "Update booking"

  input_schema(
    properties: {
      booking_id: { type: 'integer', description: 'Unique Pike13 booking ID to update' },
      attributes: { type: 'object', description: 'Booking attributes to update' }
    },
    required: %w[booking_id attributes]
  )

  class << self
    def call(booking_id:, attributes:, server_context:)
      Pike13::Desk::Booking.update(booking_id, attributes).to_json
    end
  end
end

class DeskDeleteBooking < Pike13BaseTool
  description "Delete booking"

  input_schema(
    properties: {
      booking_id: { type: 'integer', description: 'Unique Pike13 booking ID to cancel' }
    },
    required: ['booking_id']
  )

  class << self
    def call(booking_id:, server_context:)
      Pike13::Desk::Booking.destroy(booking_id).to_json
    end
  end
end

class DeskCreateBookingLease < Pike13BaseTool
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
      Pike13::Desk::Booking.create_lease(booking_id, attributes).to_json
    end
  end
end

class DeskUpdateBookingLease < Pike13BaseTool
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
      Pike13::Desk::Booking.update_lease(booking_id, lease_id, attributes).to_json
    end
  end
end
