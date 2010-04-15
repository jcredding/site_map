require File.join('test', 'test_helper')

class MapTest < Test::Unit::TestCase

  context "SiteMap::Map" do
    setup{ SiteMap.setup }

    context "instance" do
      setup{ @map = SiteMap::Map.new }
      subject{ @map }

      # Test ancestors or included modules
      should "have included SiteMap::Helpers::Mapping" do
        assert SiteMap::Map.ancestors.include?(SiteMap::Helpers::Mapping)
      end

      # Test attributes, base respond_to?, not the logic in the methods
      [ SiteMap::Map::ATTRIBUTES,
        [ :views, :group, :view, :find, :add_to_children, :add_to_index, :map, :view_node_params ]
      ].flatten.each do |attribute|
        should "respond to #{attribute}" do
          assert subject.respond_to?(attribute)
        end
      end

      # Test initialize method
      should "set it's view_nodes to an empty array" do
        assert subject.view_nodes.is_a?(Array)
        assert subject.view_nodes.empty?
      end
      should "set it's index_of_nodes to an empty hash" do
        assert subject.index_of_nodes.is_a?(Hash)
        assert subject.index_of_nodes.empty?
      end
    end

    # Test methods logic
    context "configured" do
      setup{ @map = SiteMap.map.dup }
      subject{ @map }

      should "return a node with the matching index with find" do
        assert view_node = subject.find(:godzilla_links)
        assert :godzilla_links, view_node.index
      end
      should "return nil when a node can't be found with find" do
        assert_nil subject.find(:this_so_does_not_exist)
      end
      should "clear out view_nodes and index_of_nodes with clear_nodes!" do
        assert !subject.view_nodes.empty?
        assert !subject.index_of_nodes.empty?
        subject.clear_nodes!
        assert subject.view_nodes.empty?
        assert subject.index_of_nodes.empty?
      end
    end

  end

end