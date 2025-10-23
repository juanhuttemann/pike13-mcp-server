# frozen_string_literal: true

require_relative 'base_tool'

class Pike13FrontListStaffMembers < Pike13BaseTool
  description '[CLIENT] List public staff/instructors. Returns staff with name, bio, photo, specialties, and services they provide. Use to display instructor profiles to customers or show available practitioners for appointment booking.'

  def call
    client.front.staff_members.all.to_json
  end
end

class Pike13DeskListStaffMembers < Pike13BaseTool
  description '[STAFF] List all staff members with admin details. Returns staff with employment status, permissions, pay rates, schedule availability, services assigned, and contact info. Use for staff management, payroll, or scheduling operations.'

  def call
    client.desk.staff_members.all.to_json
  end
end
