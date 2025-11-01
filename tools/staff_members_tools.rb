# frozen_string_literal: true

require_relative 'base_tool'

class FrontListStaffMembers < Pike13BaseTool
  description <<~DESC
    [CLIENT] List staff members visible to clients.

    Returns staff with name (first_name/middle_name/last_name), bio, and profile_photo URLs
    (x50/x100/x200/x400 sizes).

    Does not return staff members hidden from clients.

    Use to display instructor profiles to customers or show available practitioners for appointment booking.
  DESC

  class << self
    def call(server_context:)
      Pike13::Front::StaffMember.all.to_json
    end
  end
end

class FrontGetStaffMember < Pike13BaseTool
  description <<~DESC
    [CLIENT] Get staff member details by ID.

    Returns staff member: name, bio, and profile_photo URLs.

    Returns HTTP 404 if staff member is hidden from clients.

    Use to show detailed staff profile information.
  DESC

  input_schema(
    properties: {
      staff_member_id: { type: 'integer', description: 'Unique Pike13 staff member ID' }
    },
    required: ['staff_member_id']
  )

  class << self
    def call(staff_member_id:, server_context:)
      Pike13::Front::StaffMember.find(staff_member_id).to_json
    end
  end
end

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
