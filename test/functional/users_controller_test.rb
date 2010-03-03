require File.join('test', 'functional_test_helper')

# configure site_map to use the multiple files for configuration
files_path = File.expand_path(File.join(File.dirname(__FILE__), '..', 'support', 'config', 'site_map', '*.rb'))
files = Dir[files_path].sort
SiteMap.setup(files)

class UsersController < ApplicationController
  before_filter :view_node

  helper_method :users_path, :user_path, :view_node_label_options

  def index
  end
  def new
  end
  def show
    @user = 'Joe'
    render(:action => :index)
  end

  protected

  # this would really be in a UsersHelper in rails, but this works
  def view_node_label_options
    { :user_name => @user }
  end

  def users_path
    '/users'
  end
  def user_path
    '/users/1'
  end
end

class UsersControllerTest < ActionController::TestCase
  tests UsersController

  # testing view helpers and linking with an action controller (rails)
  context "UsersController" do
    context "on GET to :index" do
      setup{ get(:index) }

      should_assign_to :view_node
      should "return the view node's label, url and visibility in the index html response" do
        assert_equal('User List => /users => visible', @controller.response.body.strip)
      end
    end
    context "on GET to :new" do
      setup{ get(:new) }

      should_assign_to :view_node
      should "assign the index view node" do
        assert_equal(SiteMap[:users__index], assigns(:view_node))
      end
      should "return the display_title helper output, 'Users > New'" do
        assert_equal("Users > User List", @controller.response.body.strip)
      end
    end
    context "on GET to :show" do
      setup{ get(:show) }

      should_assign_to :view_node
      should "return the view node's label, url and visibility in the show html response" do
        assert_equal('User Joe => /users/1 => invisible', @controller.response.body.strip)
      end
    end
  end

end