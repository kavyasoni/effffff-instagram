ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'
require 'capybara/rspec'
require 'capybara/poltergeist'
require 'omniauth'
require 'omniauth-instagram'
require 'database_cleaner'

include ActionDispatch::TestProcess
Capybara.javascript_driver = :poltergeist
Capybara.ignore_hidden_elements = true
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.include FactoryGirl::Syntax::Methods
  config.include Capybara::DSL

  config.use_transactional_fixtures = false
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
    ActiveRecord::Base.connection.execute("DEALLOCATE ALL")
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
   end

  config.before(:each, :js => true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end

# For poltergeist to be able to login with devise
class ActiveRecord::Base
  mattr_accessor :shared_connection
  @@shared_connection = nil

  def self.connection
    @@shared_connection || retrieve_connection
  end
end

# Forces all threads to share the same connection. This works on
# Capybara because it starts the web server in a thread.
ActiveRecord::Base.shared_connection = ActiveRecord::Base.connection

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end

OmniAuth.config.test_mode = true
OmniAuth.config.logger = Logger.new("/dev/null")

def set_omniauth
  OmniAuth.config.mock_auth[:instagram] = OmniAuth::AuthHash.new({
    credentials: { provider: 'instagram', token: 'abc' },
    uid: 12345,
    info: { nickname: 'nicky_name', name: 'Nicky', email: 'n@n.com' },
    extra: { raw_info: { } }
  })
end

def set_invalid_omniauth
  credentials = { :provider => :instagram, :invalid  => :invalid_crendentials }
  OmniAuth.config.mock_auth[credentials[:provider]] = credentials[:invalid]
end