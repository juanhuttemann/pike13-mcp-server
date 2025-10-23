# frozen_string_literal: true

require_relative 'base_tool'

class Pike13FrontListStaffMembers < Pike13BaseTool
  description '[CLIENT] List staff members'

  def call
    client.front.staff_members.all.to_json
  end
end

class Pike13DeskListStaffMembers < Pike13BaseTool
  description '[STAFF] List all staff members'

  def call
    client.desk.staff_members.all.to_json
  end
end
