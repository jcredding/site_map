module SiteMap
  module Helpers

    module Mapping

      def group(index, options={})
        view_node = SiteMap::ViewNode.new(*view_node_params(index, options))
        self.view_nodes << view_node
        yield view_node if block_given?
      end
      def view(index, options={})
        view_node = SiteMap::ViewNode.new(*view_node_params(index, options))
        self.view_nodes << view_node
        self.map.add_to_index(view_node)
        yield view_node if block_given?
      end

    end

  end
end