# frozen_string_literal: true

require_relative '../base_tool'

class FrontListStaffMembers < Pike13BaseTool
  description "List staff members"

  class << self
    def call(server_context:)
      Pike13::Front::StaffMember.all.to_json
    end
  end
end

class FrontGetStaffMember < Pike13BaseTool
  description "Get staff member"

  input_schema(
    properties: {
      staff_member_id: { type: 'integer', description: 'Staff member ID' }
    },
    required: ['staff_member_id']
  )

  class << self
    def call(staff_member_id:, server_context:)
      Pike13::Front::StaffMember.find(staff_member_id).to_json
    end
  end
end
