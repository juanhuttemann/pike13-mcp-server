# frozen_string_literal: true

require_relative 'base_tool'

class DeskGetMakeUp < Pike13BaseTool
  description <<~DESC
    [STAFF] Get make-up credit details by ID.
    Returns make-up object with credit amount, reason, original visit reference, expiration date, usage status, and person details.
    Use to verify make-up credits or track unused credits.
  DESC

  arguments do
    required(:make_up_id).filled(:integer).description('Unique Pike13 make-up ID (integer)')
  end

  def call(make_up_id:)
    Pike13::Desk::MakeUp.find(make_up_id).to_json
  end
end

class DeskListMakeUpReasons < Pike13BaseTool
  description <<~DESC
    [STAFF] List all configured make-up reasons.
    Returns array of make-up reason objects with ID, name, and description.
    Use when creating make-up credits to select appropriate reason, or for reporting on make-up categories.
  DESC

  def call
    Pike13::Desk::MakeUp.reasons.to_json
  end
end

class DeskGenerateMakeUp < Pike13BaseTool
  description <<~DESC
    [STAFF] Generate make-up credit for a missed visit.
    Creates credit that customer can use for future bookings.
    Requires visit_id and make_up_reason_id.
    Returns created make-up object.
    Use when issuing make-up credits for missed classes, cancelled sessions, or service recovery.
  DESC

  arguments do
    required(:visit_id).filled(:integer).description('Unique Pike13 visit ID to generate make-up for (integer)')
    required(:make_up_reason_id).filled(:integer).description('Make-up reason ID (get from DeskListMakeUpReasons)')
    optional(:free_form_reason).maybe(:string).description('Optional: Additional free-form text explaining the reason')
  end

  def call(visit_id:, make_up_reason_id:, free_form_reason: nil)
    params = {
      visit_id: visit_id,
      make_up_reason_id: make_up_reason_id
    }
    params[:free_form_reason] = free_form_reason if free_form_reason

    Pike13::Desk::MakeUp.generate(**params).to_json
  end
end
