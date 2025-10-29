# frozen_string_literal: true

require_relative 'base_tool'

class DeskGetPunch < Pike13BaseTool
  description <<~DESC
    [STAFF] Get individual punch (class credit) by ID.

    Returns punch with visit_id, plan_id, and created_at timestamp.

    A punch pays for a visit with a plan (membership or pack).

    Use to verify punch usage, resolve billing disputes, or track plan consumption.
  DESC

  arguments do
    required(:punch_id).filled(:integer).description('Unique Pike13 punch ID')
  end

  def call(punch_id:)
    Pike13::Desk::Punch.find(punch_id).to_json
  end
end

class DeskCreatePunch < Pike13BaseTool
  description <<~DESC
    [STAFF] Create a punch to pay for a visit with a plan.

    Creates a punch linking a visit to a plan (membership or pack).
    If plan_id is omitted, the system attempts to automatically find a suitable plan.

    Returns created punch with visit_id, plan_id, and created_at.

    Use to manually apply plan credits to visits or resolve payment issues.
  DESC

  arguments do
    required(:visit_id).filled(:integer).description('Visit ID to pay for')
    optional(:plan_id).maybe(:integer).description('Optional: plan ID to use (auto-selected if omitted)')
  end

  def call(visit_id:, plan_id: nil)
    params = { visit_id: visit_id }
    params[:plan_id] = plan_id if plan_id
    Pike13::Desk::Punch.create(params).to_json
  end
end

class DeskDeletePunch < Pike13BaseTool
  description <<~DESC
    [STAFF] Delete a punch.

    Destroys the punch. The associated visit will become unpaid.

    Use to reverse incorrect punch usage or correct billing errors.
  DESC

  arguments do
    required(:punch_id).filled(:integer).description('Punch ID to delete')
  end

  def call(punch_id:)
    Pike13::Desk::Punch.delete(punch_id).to_json
  end
end
