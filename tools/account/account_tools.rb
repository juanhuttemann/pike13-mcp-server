# frozen_string_literal: true

require_relative '../base_tool'

# Account-level tools
class AccountGetMe < Pike13BaseTool
  description "Get current user account info"

  class << self
    def call(server_context:)
      Pike13::Account.me.to_json
    end
  end
end

class AccountListPeople < Pike13BaseTool
  description "List all people across all businesses tied to the current account"

  class << self
    def call(server_context:)
      Pike13::Account::Person.all.to_json
    end
  end
end

class AccountCreateConfirmation < Pike13BaseTool
  description "Resend email confirmation for account verification"

  input_schema(
    properties: {
      email: { type: 'string', description: 'Email address' }
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
  description "Request password reset email"

  input_schema(
    properties: {
      email: { type: 'string', description: 'Email address' }
    },
    required: ['email']
  )

  class << self
    def call(email:, server_context:)
      Pike13::Account::Password.create(email: email).to_json
    end
  end
end
