#!/usr/bin/env ruby
# frozen_string_literal: true

require 'bundler/setup'
Bundler.require(:default)
require 'fast_mcp'
require 'rack'

# Load Pike13 tools
Dir[File.join(__dir__, 'tools', '*_tools.rb')].each { |file| require file }

# Middleware to pass Rack env to thread for header access
class EnvMiddleware
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
    AccountListBusinesses, FrontGetBusiness, FrontGetBranding, DeskGetBusiness,
    # People
    AccountGetMe, FrontGetMe, DeskListPeople, DeskGetPerson, DeskSearchPeople, DeskGetMe,
    # Events
    FrontListEvents, FrontGetEvent, DeskListEvents, DeskGetEvent,
    # Event Occurrences
    FrontListEventOccurrences, FrontGetEventOccurrence, DeskListEventOccurrences, DeskGetEventOccurrence,
    # Appointment Availability
    FrontFindAvailableAppointmentSlots, FrontGetAppointmentAvailabilitySummary,
    DeskFindAvailableAppointmentSlots, DeskGetAppointmentAvailabilitySummary,
    # Visits
    FrontListVisits, FrontGetVisit, DeskListVisits, DeskGetVisit,
    # Locations
    FrontListLocations, DeskListLocations,
    # Services
    FrontListServices, DeskListServices,
    # Staff Members
    FrontListStaffMembers, DeskListStaffMembers,
    # Plans
    FrontListPlans, DeskListPlans,
    # Plan Products
    FrontListPlanProducts, DeskListPlanProducts,
    # Pack Products
    DeskListPackProducts,
    # Invoices
    FrontGetInvoice, DeskListInvoices,
    # Revenue Categories
    DeskListRevenueCategories,
    # Sales Taxes
    DeskListSalesTaxes,
    # Custom Fields
    DeskListCustomFields,
    # Waitlist Entries
    FrontGetWaitlistEntry, DeskListWaitlistEntries,
    # Bookings
    FrontGetBooking, DeskGetBooking,
    # Packs
    DeskGetPack,
    # Punches
    DeskGetPunch
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
  use EnvMiddleware
  run mcp_app
end
config = Puma::Configuration.new do |user_config|
  user_config.bind 'tcp://0.0.0.0:9292'
  user_config.app app
end

launcher = Puma::Launcher.new(config)
launcher.run