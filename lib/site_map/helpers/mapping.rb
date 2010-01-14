module SiteMap
  module Helpers

    module Mapping

      def group(index, options={})
        view_node = SiteMap::ViewNode.new(index, :group, options.merge(merge_options))
        self.view_nodes << view_node
        yield view_node if block_given?
      end
      def view(index, options={})
        view_node = SiteMap::ViewNode.new(index, :view, options.merge(merge_options))
        self.view_nodes << view_node
        yield view_node if block_given?
      end

      protected

      def merge_options
        case self
        when SiteMap::Map
          { :map => self }
        when SiteMap::ViewNode
          { :map => self.map, :parent_index => self.parent_index }
        else
          {}
        end
      end

    end

  end
end