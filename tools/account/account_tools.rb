# frozen_string_literal: true

require_relative '../base_tool'

# Account-level tools
class AccountGetMe < Pike13BaseTool
  description <<~DESC
    [ACCOUNT] Get account-level user info ONLY.
    Returns account object with ID, email, name.
    Use ONLY when user asks about their account, billing, or businesses they own.
    NOT needed for regular business operations like booking, events, or services.
  DESC

  class << self
    def call(server_context:)
      Pike13::Account.me.to_json
    end
  end
end

class AccountListPeople < Pike13BaseTool
  description <<~DESC
    [ACCOUNT] List all people across all businesses in the account.
    Returns paginated array of person objects from all associated businesses.
    Use for account-wide user management or reporting across multiple businesses.
  DESC

  class << self
    def call(server_context:)
      Pike13::Account::Person.all.to_json
    end
  end
end

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
