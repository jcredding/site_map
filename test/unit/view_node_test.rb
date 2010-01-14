require File.dirname(__FILE__) + '/../test_helper'

class ViewNodeTest < Test::Unit::TestCase

  context "ViewNode" do
    setup do
      @view_node = SiteMap::ViewNode.new(:test_node, SiteMap.map)
    end
    subject{ @view_node }

    # Test ancestors or included modules
    should "have included SiteMap::Helpers::Mapping" do
      assert SiteMap::ViewNode.ancestors.include?(SiteMap::Helpers::Mapping)
    end

    # Test attributes, base respond_to?, not the logic in the methods
    [ SiteMap::ViewNode::ATTRIBUTES,
      [ :[] ]
    ].flatten.each do |attribute|
      should "respond to #{attribute}" do
        assert subject.respond_to?(attribute)
      end
    end

    # Test initialize method and attribute method's logic
    should "set it's index to :test_node" do
      assert_equal :test_node, subject.index
    end
    should "set it's view_nodes to an empty array" do
      assert subject.view_nodes.is_a?(Array)
      assert subject.view_nodes.empty?
    end
    should "return the value of attributes with [attribute], bypassing reader methods" do
      assert_nil subject[:label]
      assert_nil subject[:url]
      assert_nil subject[:show]
      assert_nil subject[:parent_index]
    end
    should "return the index as a string" do
      assert_equal subject.index.to_s, subject.label
    end
    should "return 'true' with show" do
      assert_equal 'true', subject.show
    end

    # Test initialize method with attributes being set
    context "initialized with options" do
      setup do
        @view_node = SiteMap::ViewNode.new(:test_node, SiteMap.map, {
          :label => 'Manually created',
          :url => "'/never/will/work'",
          :show => "want_to?",
          :parent_index => 'doesnt_exist'
        })
      end
      subject{ @view_node }

      should "set it's label to 'Manually created'" do
        assert_equal 'Manually created', subject.label
      end
      should "set it's url to \"'/never/will/work'\"" do
        assert_equal "'/never/will/work'", subject.url
      end
      should "set it's show to 'want_to?'" do
        assert_equal 'want_to?', subject.show
      end
      should "set it's map to SiteMap.map" do
        assert_equal SiteMap.map, subject.map
      end
      should "set it's parent_index to :doesnt_exist" do
        assert_equal :doesnt_exist, subject.parent_index
      end
    end
  end

end