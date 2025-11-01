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
    AccountCreateConfirmation, AccountCreatePasswordReset, AccountGetBusiness, AccountGetMe,
    AccountListBusinesses, AccountListPeople, DeskCreateBooking, DeskCreateBookingLease,
    DeskCreateEventOccurrenceNote, DeskCreateFormOfPayment, DeskCreateInvoice, DeskCreateInvoiceItem,
    DeskCreateInvoiceItemDiscount, DeskCreateInvoiceItemProrate, DeskCreateInvoicePayment, DeskCreateInvoiceRefund,
    DeskCreateNote, DeskCreatePackFromProduct, DeskCreatePackProduct, DeskCreatePerson,
    DeskCreatePunch, DeskCreateVisit, DeskCreateWaitlistEntry, DeskDeleteBooking,
    DeskDeleteEventOccurrenceNote, DeskDeleteFormOfPayment, DeskDeleteInvoiceItem, DeskDeleteInvoiceItemDiscounts,
    DeskDeleteInvoiceItemProrate, DeskDeleteNote, DeskDeletePack, DeskDeletePackProduct,
    DeskDeletePerson, DeskDeletePunch, DeskDeleteVisit, DeskDeleteWaitlistEntry,
    DeskFindAvailableAppointmentSlots, DeskGenerateMakeUp, DeskGetAppointmentAvailabilitySummary, DeskGetBooking,
    DeskGetBusiness, DeskGetBusinessFranchisees, DeskGetEvent, DeskGetEventOccurrence,
    DeskGetEventOccurrenceEnrollmentEligibilities, DeskGetEventOccurrenceNote, DeskGetEventOccurrencesSummary, DeskGetFormOfPayment,
    DeskGetInvoice, DeskGetInvoiceItemDiscounts, DeskGetInvoicePaymentMethods, DeskGetLocation,
    DeskGetMakeUp, DeskGetMe, DeskGetNote, DeskGetPack,
    DeskGetPackProduct, DeskGetPayment, DeskGetPaymentConfiguration, DeskGetPerson,
    DeskGetPlanProduct, DeskGetPunch, DeskGetRevenueCategory, DeskGetSalesTax,
    DeskGetService, DeskGetServiceEnrollmentEligibilities, DeskGetStaffMember, DeskGetVisit,
    DeskGetWaitlistEntry, DeskListCustomFields, DeskListEventOccurrenceNotes, DeskListEventOccurrenceVisits,
    DeskListEventOccurrenceWaitlistEntries, DeskListEventOccurrences, DeskListEvents, DeskListFormsOfPayment,
    DeskListInvoices, DeskListLocations, DeskListMakeUpReasons, DeskListNotes,
    DeskListPackProducts, DeskListPacks, DeskListPeople, DeskListPersonPlans,
    DeskListPersonVisits, DeskListPersonWaitlistEntries, DeskListPersonWaivers, DeskListPlanProducts,
    DeskListPlans, DeskListRevenueCategories, DeskListSalesTaxes, DeskListServices,
    DeskListStaffMembers, DeskListVisits, DeskListWaitlistEntries, DeskSearchPeople,
    DeskUpdateBooking, DeskUpdateBookingLease, DeskUpdateEventOccurrenceNote, DeskUpdateFormOfPayment,
    DeskUpdateInvoice, DeskUpdateNote, DeskUpdatePackProduct, DeskUpdatePerson,
    DeskUpdatePlanEndDate, DeskUpdateVisit, DeskUpdateWaitlistEntry, DeskVoidPayment,
    DeskVoidRefund, FrontCompletePlanTerms, FrontCreateBooking, FrontCreateBookingLease,
    FrontCreateFormOfPayment, FrontCreateInvoice, FrontCreateInvoiceItem, FrontCreateInvoicePayment,
    FrontCreateVisit, FrontCreateWaitlistEntry, FrontDeleteBooking, FrontDeleteBookingLease,
    FrontDeleteFormOfPayment, FrontDeleteInvoiceItem, FrontDeleteInvoicePayment, FrontDeleteVisit,
    FrontDeleteWaitlistEntry, FrontFindAvailableAppointmentSlots, FrontGetAppointmentAvailabilitySummary, FrontGetBooking,
    FrontGetBookingLease, FrontGetBranding, FrontGetBusiness, FrontGetBusinessFranchisees,
    FrontGetEvent, FrontGetEventOccurrence, FrontGetEventOccurrenceEnrollmentEligibilities, FrontGetEventOccurrenceNote,
    FrontGetEventOccurrencesSummary, FrontGetFormOfPayment, FrontGetFormOfPaymentMe, FrontGetInvoice,
    FrontGetInvoicePaymentMethods, FrontGetLocation, FrontGetMe, FrontGetNote,
    FrontGetPayment, FrontGetPaymentConfiguration, FrontGetPlanProduct, FrontGetPlanTerms,
    FrontGetService, FrontGetServiceEnrollmentEligibilities, FrontGetStaffMember, FrontGetVisit,
    FrontGetWaitlistEntry, FrontListEventOccurrenceNotes, FrontListEventOccurrenceWaitlistEligibilities, FrontListEventOccurrences,
    FrontListEvents, FrontListFormsOfPayment, FrontListInvoices, FrontListLocations,
    FrontListNotes, FrontListPersonPlans, FrontListPersonVisits, FrontListPersonWaitlistEntries,
    FrontListPersonWaivers, FrontListPlanProducts, FrontListPlanTerms, FrontListServices,
    FrontListStaffMembers, FrontListVisits, FrontUpdateBooking, FrontUpdateBookingLease,
    FrontUpdateFormOfPayment, FrontUpdateInvoice
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
