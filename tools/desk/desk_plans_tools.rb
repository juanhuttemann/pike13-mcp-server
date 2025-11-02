# frozen_string_literal: true

require_relative '../base_tool'

class DeskListPlans < Pike13BaseTool
  description <<~DESC
    List all plans (memberships and packs) for the business.

    Returns plans with type (Pack/Membership), count (visit limit), people (id/email/name),
    name, plan_product_id, staff_member_id, description, price_cents, start_date, end_date,
    cancelled_at, limit_period, location_id, and optionally holds (if include_holds=true).

    Use for plan management, reporting, or membership/pack administration.
  DESC

  input_schema(
    properties: {
      include_holds: { type: 'boolean',
                       description: 'Optional: include active and upcoming holds on each plan (boolean)' }
    },
    required: []
  )

  class << self
    def call(server_context:, include_holds: nil)
      params = {}
      params[:include_holds] = include_holds if include_holds
      Pike13::Desk::Plan.all(**params).to_json
    end
  end
end

class DeskUpdatePlanEndDate < Pike13BaseTool
  description <<~DESC
    Update the end date for a specific plan.

    Updates plan end_date. End date must be in the future and cannot be at or after
    the next billing cycle date.

    Returns updated end_date, plan details, and cancellation_fee_request if applicable
    (with invoice details and total_cents).

    Use to modify plan expiration dates or handle early cancellations.
  DESC

  input_schema(
    properties: {
      plan_id: { type: 'integer', description: 'Unique Pike13 plan ID' },
      end_date: { type: 'string', description: 'New end date (YYYY-MM-DD format, must be in future)' }
    },
    required: %w[plan_id end_date]
  )

  class << self
    def call(plan_id:, end_date:, server_context:)
      params = { end_date: end_date }
      Pike13::Desk::Plan.update_end_date(plan_id, params).to_json
    end
  end
end
