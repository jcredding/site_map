require File.join('test', 'test_helper')

class SiteMapTest < Test::Unit::TestCase

  context "SiteMap module" do
    setup{ SiteMap.setup }
    subject{ SiteMap }

    [:define, :setup, :[], :view_nodes, :views].each do |method|
      should "respond to #{method}" do
        assert subject.respond_to?(method)
      end
    end

    context "define method" do
      setup{ SiteMap.define{|map| @map = map} }
      subject{ @map }

      should "yield it's map to given block" do
        assert subject.kind_of?(SiteMap::Map)
      end
    end

    should "proxy map.find with []" do
      assert_equal SiteMap.map.find(:godzilla_links), SiteMap[:godzilla_links]
    end
    should "proxy map view_nodes with view_nodes" do
      assert_equal SiteMap.map.view_nodes, SiteMap.view_nodes
    end
  end

  context "SiteMap setup with multiple, non-default files" do
    setup do
      files_path = File.expand_path(File.join(File.dirname(__FILE__), '..', 'support', 'config', 'site_map', '*.rb'))
      files = Dir[files_path].sort
      SiteMap.setup(files)
    end
    subject{ SiteMap }

    # check member / collection methods defining
    [ [:index, [:new, :create]],
      [:show, [:edit, :update, :destroy]]
    ].each do |action_and_alias|
      action_and_alias.flatten.each do |action|
        should "define 'users__#{action}' indexed node" do
          action_index = "users__#{action}".to_sym
          assert (view_node = SiteMap[action_index])
        end
      end
      action_and_alias.last.each do |action|
        should "should return the 'users__#{action_and_alias.first}' with 'users__#{action}'" do
          action_index = "users__#{action}".to_sym
          assert (view_node = SiteMap[action_index])
          assert_not_equal action_index, view_node.index
          assert_equal "users__#{action_and_alias.first}".to_sym, view_node.index
        end
      end
    end

    should "contain users site map configuration" do
      view_node = SiteMap[:users__index]
      assert view_node
      user_group_node = SiteMap.view_nodes.detect{|vn| vn.index == :users}
      assert_equal user_group_node, view_node.parent
      assert_equal [SiteMap[:users__show]], view_node.children
      view_node = SiteMap[:messages__index]
      assert view_node
      project_index_node = SiteMap[:projects__index]
      assert_equal project_index_node, view_node.parent
      expected_children = [SiteMap[:messages__show], SiteMap[:messages__edit], SiteMap[:messages__approve]]
      assert_equal expected_children, view_node.children
    end
  end

end