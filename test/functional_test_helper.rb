require File.join('test', 'test_helper')

require 'active_support'
require 'action_controller'
require 'action_controller/test_case'
require 'action_controller/test_process'
require 'shoulda/action_controller'

class ApplicationController < ActionController::Base
  helper SiteMap::ViewHelpers

  def view_node
    @view_node ||= SiteMap["#{self.controller_name}__#{self.action_name}"]
  end
end

ActionController::Base.view_paths = File.join('test', 'support', 'views')

ActionController::Routing::Routes.draw do |map|
  map.connect ':controller/:action/:id'
end
