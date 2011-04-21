require File.expand_path('../boot', __FILE__)

require "action_controller/railtie"
require "action_mailer/railtie"
require "active_resource/railtie"
require "rails/test_unit/railtie"

Bundler.require(:default)

module RailsApp
  class Application < Rails::Application
    # Add additional load paths for your own custom dirs
    config.root = ENV["RAILS_ROOT"]

    # Configure generators values. Many other options are available, be sure to check the documentation.
    # config.generators do |g|
    #   g.orm             :active_record
    #   g.template_engine :erb
    #   g.test_framework  :test_unit, :fixture => true
    # end

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters << :password

    config.action_mailer.default_url_options = { :host => "localhost:3000" }
  end
end

require File.expand_path("../environments/test.rb", __FILE__)
require File.expand_path("../routes.rb", __FILE__)

Dir[File.expand_path("../../app/controllers/*.rb", __FILE__)].each do |controller|
  require controller
end
