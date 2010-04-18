require File.join('test', 'test_helper')

class ViewNodeTest < Test::Unit::TestCase

  context "ViewNode" do
    setup do
      SiteMap.setup
      @view_node = SiteMap::ViewNode.new(:test_node, SiteMap.map, :view)
    end
    subject{ @view_node }

    # Test ancestors or included modules
    should "have included SiteMap::Helpers::Mapping" do
      assert SiteMap::ViewNode.ancestors.include?(SiteMap::Helpers::Mapping)
    end

    # Test attributes, base respond_to?, not the logic in the methods
    [ SiteMap::ViewNode::ATTRIBUTES,
      [ :visible?, :view?, :group? ],
      [ :children, :views],
      [ :ancestors, :self_and_ancestors, :sna],
      [ :siblings, :self_and_siblings, :sns ],
      [ :previous_sibling, :previous_view, :prev],
      [ :next_sibling, :next_view, :next],
      [ :view_node_params, :[] ]
    ].flatten.each do |attribute|
      should "respond to #{attribute}" do
        assert subject.respond_to?(attribute)
      end
    end

    # Test initialize method and attribute method's logic
    should "raise an ArgumentError when no index, map or node_type is provided" do
      assert_raises(ArgumentError){ SiteMap::ViewNode.new }
    end
    should "set it's index to :test_node" do
      assert_equal :test_node, subject.index
    end
    should "set it's children (view_nodes) to an empty array" do
      assert subject.children.is_a?(Array)
      assert subject.children.empty?
    end
    should "return the value of attributes with [attribute], bypassing reader methods" do
      assert_nil subject[:label]
      assert_nil subject[:url]
      assert_nil subject[:visible]
    end

    should "provide a logical default label" do
      assert_equal "Test Node", subject.label
    end

    should "provide a logical default url" do
      assert_equal "/test_node", subject.url
    end

    should "return 'true' with visible" do
      assert_equal true, subject.visible
    end

    # Test initialize method with attributes being set
    context "initialized with options" do
      setup do
        @view_node = SiteMap::ViewNode.new(:test_node, SiteMap.map, :view, {
          :label => 'Manually created',
          :url => "'/never/will/work'",
          :visible => "want_to?"
        })
      end
      subject{ @view_node }

      should "set it's label to 'Manually created'" do
        assert_equal 'Manually created', subject.label
      end
      should "set it's url to \"'/never/will/work'\"" do
        assert_equal "'/never/will/work'", subject.url
      end
      should "set it's visible to 'want_to?'" do
        assert_equal 'want_to?', subject.visible
      end
      should "set it's map to SiteMap.map" do
        assert_equal SiteMap.map, subject.map
      end
      should "return true with view?" do
        assert subject.view?
      end
    end

    context "initialized with explicit true visible option" do
      setup do
        @view_node = SiteMap::ViewNode.new(:test_node, SiteMap.map, :view, {
          :visible => true
        })
      end
      subject{ @view_node }

      should "honor the option" do
        assert_equal true, subject.visible
      end
    end

    context "initialized with explicit false visible option" do
      setup do
        @view_node = SiteMap::ViewNode.new(:test_node, SiteMap.map, :view, {
          :visible => false
        })
      end
      subject{ @view_node }

      should "honor the option" do
        assert_equal false, subject.visible
      end
    end

    # Test relationship methods
    context "from the configured set" do
      setup{ @view_node = SiteMap[:godzilla_about] }
      subject{ @view_node }

      should "return godzilla group node with parent" do
        assert_equal SiteMap.map.view_nodes.first, subject.parent
      end
      should "return about_movies and about_monsters with children" do
        children_should_be = [SiteMap[:about_movies], SiteMap[:about_monsters], SiteMap[:about_rodan]]
        assert_equal children_should_be, subject.children
      end
      should "return godzilla_links node with siblings" do
        assert_equal [SiteMap[:godzilla_links]], subject.siblings
      end
      should "return godzilla_links with subject with self_and_siblings" do
        assert_equal [subject, SiteMap[:godzilla_links]], subject.self_and_siblings
      end
    end
    context "the about_movies node" do
      setup{ @view_node = SiteMap[:about_movies] }
      subject{ @view_node }

      should "return godzilla group and godzilla_about with ancestors" do
        ancestors_should_be = [SiteMap.map.view_nodes.first, SiteMap[:godzilla_about]]
        assert_equal ancestors_should_be, subject.ancestors
      end
      should "return godzilla group, godzilla_about and about_movies with self_and_ancestors" do
        ancestors_should_be = [SiteMap.map.view_nodes.first, SiteMap[:godzilla_about], subject]
        assert_equal ancestors_should_be, subject.self_and_ancestors
      end
    end
    context "group from the configured set" do
      setup{ @view_node = SiteMap.view_nodes.first }
      subject{ @view_node }

      should "return true with group?" do
        assert subject.group?
      end
      should "return it's first child's url for it's url" do
        assert_equal subject.children.first.url, subject.url
      end
    end
    context "alias from the configured set" do
      setup{ @view_node = SiteMap[:godzilla_urls] }
      subject{ @view_node }

      should "should be the same as godzilla_links" do
        assert_equal SiteMap[:godzilla_links], @view_node
      end
      should "raise non existant view node exception" do
        assert_raises(SiteMap::Exceptions::NonExistantViewNode) do
          SiteMap.define{|map| map.alias(:wont_work, :doesnt_exist) }
        end
      end
    end
    context "with siblings" do
      setup do
        @view1 = SiteMap[:about_movies]
        @view2 = SiteMap[:about_monsters]
        @view3 = SiteMap[:about_rodan]
      end
      
      should "be able to cycle to it's previous and next views" do
        assert_equal @view3, @view1.previous_sibling
        assert_equal @view2, @view1.next_sibling
        assert_equal @view1, @view2.previous_view
        assert_equal @view3, @view2.next_view
        assert_equal @view2, @view3.prev
        assert_equal @view1, @view3.next
      end
    end
    context "from the multiple file set testing smart defaults" do
      setup do
        files_path = File.expand_path(File.join(File.dirname(__FILE__), '..', 'support', 'config', 'site_map', '*.rb'))
        files = Dir[files_path].sort
        SiteMap.setup(files)
      end

      context "messages index node" do
        setup do
          @view_node = SiteMap[:messages__index]
        end
        subject{ @view_node }

        should "return 'Messages List' with label" do
          assert_equal("#{subject.resource.to_s.titleize}", subject.label)
        end
        should "return 'project_messages_path(@project)' with url" do
          assert_equal("project_messages_path(@project)", subject.url)
        end
      end
      context "messages show node" do
        setup do
          @view_node = SiteMap[:messages__show]
        end
        subject{ @view_node }

        should "return ':message_name' with label" do
          assert_equal(":#{subject.resource.to_s.singularize}_name", subject.label)
        end
        should "return 'message_path' with url" do
          single_resource = subject.resource.to_s.singularize
          assert_equal("#{single_resource}_path(@#{single_resource})", subject.url)
        end
      end
      context "messages new node" do
        setup do
          @view_node = SiteMap[:messages__new]
        end
        subject{ @view_node }

        should "not be the index node" do
          assert_not_equal(SiteMap[:messages__index], subject)
        end
        should "be the same as the create node" do
          assert_equal(SiteMap[:messages__create], subject)
        end
        should "return 'New message' with label" do
          assert_equal('New message', subject.label)
        end
        should "return 'new_project_message_path(@project)' with url" do
          assert_equal('new_project_message_path(@project)', subject.url)
        end
      end
      context "messages edit node" do
        setup do
          @view_node = SiteMap[:messages__edit]
        end
        subject{ @view_node }

        should "not be the show node" do
          assert_not_equal(SiteMap[:messages__show], subject)
        end
        should "be the same as the update node" do
          assert_equal(SiteMap[:messages__update], subject)
        end
        should "return 'Edit :message_name' with label" do
          assert_equal('Edit :message_name', subject.label)
        end
        should "return 'edit_message_path(@message)' with url" do
          assert_equal('edit_message_path(@message)', subject.url)
        end
      end
      context "messages approved node" do
        setup do
          @view_node = SiteMap[:messages__approved]
        end
        subject{ @view_node }

        should "return 'Approved Messages' with label" do
          assert_equal('Approved Messages', subject.label)
        end
        should "return 'approved_project_messages_path(@project) with url" do
          assert_equal('approved_project_messages_path(@project)', subject.url)
        end
      end
      context "messages approve node" do
        setup do
          @view_node = SiteMap[:messages__approve]
        end
        subject{ @view_node }

        should "return 'Approve :message_name' with label" do
          assert_equal('Approve :message_name', subject.label)
        end
        should "return 'approve_message_path(@message)' with url" do
          assert_equal('approve_message_path(@message)', subject.url)
        end
      end
    end
  end

end