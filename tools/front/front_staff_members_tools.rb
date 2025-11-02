# frozen_string_literal: true

require_relative "../base_tool"

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

