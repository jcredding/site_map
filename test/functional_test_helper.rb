require File.join('test', 'test_helper')

require 'action_controller/test_case'
require 'action_controller/test_process'
require 'shoulda/action_controller'

class ApplicationController < ActionController::Base; end

ActionController::Base.view_paths = File.join('test', 'support', 'views')

ActionController::Routing::Routes.draw do |map|
  map.connect ':controller/:action/:id'
end
