# frozen_string_literal: true

require_relative '../base_tool'

class DeskListStaffMembers < Pike13BaseTool
  description <<~DESC
    [STAFF] List all current staff members with administrative details.

    Returns staff with name, phone, email, role (owner/staff_member), bio, profile_photo URLs,
    and custom_fields (id/custom_field_id/name/value).

    Use for staff management, contact lookup, or administrative tasks.
  DESC

  class << self
    def call(server_context:)
      Pike13::Desk::StaffMember.all.to_json
    end
  end
end

class DeskGetStaffMember < Pike13BaseTool
  description <<~DESC
    [STAFF] Get staff member details by ID or 'me' for current user.

    Returns complete staff member data: name, phone, email, role, bio, profile_photo URLs,
    and custom_fields.

    Use 'me' as staff_member_id to fetch the profile for the current access token.

    Use for staff profile viewing or administrative management.
  DESC

  input_schema(
    properties: {
      staff_member_id: { type: 'string', description: 'Staff member ID or "me" for current user' }
    },
    required: ['staff_member_id']
  )

  class << self
    def call(staff_member_id:, server_context:)
      Pike13::Desk::StaffMember.find(staff_member_id).to_json
    end
  end
end
