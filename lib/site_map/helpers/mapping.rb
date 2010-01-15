module SiteMap
  module Helpers

    module Mapping

      def group(new_index, options={})
        view_node = SiteMap::ViewNode.new(*view_node_params(new_index, :group, options))
        self.add_to_children(view_node)
        yield view_node if block_given?
      end
      def view(new_index, options={})
        view_node = SiteMap::ViewNode.new(*view_node_params(new_index, :view, options))
        self.add_to_children(view_node)
        self.map.add_to_index(new_index, view_node)
        yield view_node if block_given?
      end

      def alias(new_index, existing_index)
        view_node = SiteMap[existing_index]
        raise(SiteMap::Exceptions::NonExistantViewNode, "view node with index #{existing_index} does not exist for aliasing") unless view_node
        self.map.add_to_index(new_index, view_node)
      end

    end

  end
end