#!/usr/bin/env ruby
# frozen_string_literal: true

require 'bundler/setup'
Bundler.require(:default)
require 'fast_mcp'
require 'rack'

# Load Pike13 tools
Dir[File.join(__dir__, 'tools', '*_tools.rb')].each { |file| require file }

# Middleware to pass Rack env to thread for header access
class Pike13EnvMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    Thread.current[:rack_env] = env
    @app.call(env)
  ensure
    Thread.current[:rack_env] = nil
  end
end

# Create a simple Rack application
app = lambda do |_env|
  [200, { 'Content-Type' => 'text/html' },
   ['<html><body><h1>Pike13 MCP Server</h1></body></html>']]
end

# Create the MCP middleware
mcp_app = FastMcp.rack_middleware(
  app,
  name: 'pike13-mcp-server', version: '1.0.0',
  logger: Logger.new($stdout),
  localhost_only: false
) do |server|
  # Register all Pike13 tools
  server.register_tools(
    # Business
    Pike13AccountListBusinesses, Pike13FrontGetBusiness, Pike13FrontGetBranding, Pike13DeskGetBusiness,
    # People
    Pike13AccountGetMe, Pike13FrontGetMe, Pike13DeskListPeople, Pike13DeskGetPerson, Pike13DeskSearchPeople, Pike13DeskGetMe,
    # Events
    Pike13FrontListEvents, Pike13FrontGetEvent, Pike13DeskListEvents, Pike13DeskGetEvent,
    # Event Occurrences
    Pike13FrontListEventOccurrences, Pike13FrontGetEventOccurrence, Pike13DeskListEventOccurrences, Pike13DeskGetEventOccurrence,
    # Appointment Availability
    Pike13FrontFindAvailableAppointmentSlots, Pike13FrontGetAppointmentAvailabilitySummary,
    Pike13DeskFindAvailableAppointmentSlots, Pike13DeskGetAppointmentAvailabilitySummary,
    # Visits
    Pike13FrontListVisits, Pike13FrontGetVisit, Pike13DeskListVisits, Pike13DeskGetVisit,
    # Locations
    Pike13FrontListLocations, Pike13DeskListLocations,
    # Services
    Pike13FrontListServices, Pike13DeskListServices,
    # Staff Members
    Pike13FrontListStaffMembers, Pike13DeskListStaffMembers,
    # Plans
    Pike13FrontListPlans, Pike13DeskListPlans,
    # Plan Products
    Pike13FrontListPlanProducts, Pike13DeskListPlanProducts,
    # Pack Products
    Pike13DeskListPackProducts,
    # Invoices
    Pike13FrontGetInvoice, Pike13DeskListInvoices,
    # Revenue Categories
    Pike13DeskListRevenueCategories,
    # Sales Taxes
    Pike13DeskListSalesTaxes,
    # Custom Fields
    Pike13DeskListCustomFields,
    # Waitlist Entries
    Pike13FrontGetWaitlistEntry, Pike13DeskListWaitlistEntries,
    # Bookings
    Pike13FrontGetBooking, Pike13DeskGetBooking,
    # Packs
    Pike13DeskGetPack,
    # Punches
    Pike13DeskGetPunch
  )
end

# Run the Rack application with Puma
puts 'Starting Rack application with MCP middleware on http://localhost:9292'
puts 'MCP endpoints:'
puts '  - http://localhost:9292/mcp/sse (SSE endpoint)'
puts '  - http://localhost:9292/mcp/messages (JSON-RPC endpoint)'
puts 'Press Ctrl+C to stop'

# Use the Puma server directly instead of going through Rack::Handler
require 'puma'
require 'puma/configuration'
require 'puma/launcher'

app = Rack::Builder.new do
  use Pike13EnvMiddleware
  run mcp_app
end
config = Puma::Configuration.new do |user_config|
  user_config.bind 'tcp://0.0.0.0:9292'
  user_config.app app
end

launcher = Puma::Launcher.new(config)
launcher.run