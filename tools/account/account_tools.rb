# frozen_string_literal: true

require_relative "../base_tool"

class AccountCreateConfirmation < Pike13BaseTool
  description <<~DESC
    [ACCOUNT] Resend email confirmation.
    Creates/resends confirmation email for account email verification.
    Use when user needs to verify their email address.
  DESC

  input_schema(
    properties: {
      email: { type: 'string', description: 'Email address to send confirmation to' }
    },
    required: ['email']
  )

  class << self
    def call(email:, server_context:)
      Pike13::Account::Confirmation.create(email: email).to_json
    end
  end
end

class AccountCreatePasswordReset < Pike13BaseTool
  description <<~DESC
    [ACCOUNT] Request password reset.
    Creates password reset request and sends reset email.
    Use when user forgot password or needs to reset it.
  DESC

  input_schema(
    properties: {
      email: { type: 'string', description: 'Email address for password reset' }
    },
    required: ['email']
  )

  class << self
    def call(email:, server_context:)
      Pike13::Account::Password.create(email: email).to_json
    end
  end
end
