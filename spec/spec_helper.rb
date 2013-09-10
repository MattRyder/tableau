require 'rubygems'
require 'spork'
#uncomment the following line to use spork with the debugger
require 'spork/ext/ruby-debug'

Spork.prefork do
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../dummy/config/environment", __FILE__)
  require 'rspec/rails'
  require 'rspec/autorun'
  require 'benchmark'


  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

  RSpec.configure do |config|
    # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
    config.fixture_path = "#{::Rails.root}/spec/fixtures"
    config.use_transactional_fixtures = true
    config.infer_base_class_for_anonymous_controllers = false
    config.order = "random"
  end
end

Spork.each_run do
  # This code will be run each time you run your specs.
  require 'tableau'
  require 'tableau/class'
  require 'tableau/classarray'

  require 'tableau/module'

  require 'tableau/baseparser'
  require 'tableau/moduleparser'

  require 'tableau/tablebuilder'
  require 'tableau/timetable'
  require 'tableau/uribuilder'

end