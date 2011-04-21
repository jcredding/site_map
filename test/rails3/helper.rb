require File.expand_path("../env", __FILE__)

rails_app_path = File.expand_path('../support/rails_app', __FILE__)
$LOAD_PATH.unshift(rails_app_path) unless $LOAD_PATH.include?(rails_app_path)
require 'config/environment'
