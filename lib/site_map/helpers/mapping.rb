module SiteMap
  module Helpers

    module Mapping

      def group(new_index, options={})
        view_node = self.add_node(new_index, :group, options)
        yield view_node if block_given?
      end
      def view(new_index, options={})
        view_node = self.add_node(new_index, :view, options)
        yield view_node if block_given?
      end

      def alias(new_index, existing_index)
        view_node = SiteMap[existing_index]
        raise(SiteMap::Exceptions::NonExistantViewNode, "view node with index #{existing_index} does not exist for aliasing") unless view_node
        self.map.add_to_index(new_index, view_node)
      end

      def collection(resource, options={})
        base_index = "#{resource}__:action"
        new_index = base_index.gsub(':action', 'index').to_sym
        view_node = self.add_node(new_index, :view, options)
        [:new, :create].each do |action|
          action_index = base_index.gsub(':action', action.to_s).to_sym
          view_node.alias(action_index, new_index)
        end
        yield view_node if block_given?
      end
      def member(resource, options={})
        base_index = "#{resource}__:action"
        new_index = base_index.gsub(':action', 'show').to_sym
        view_node = self.add_node(new_index, :view, options)
        [:edit, :update, :destroy].each do |action|
          action_index = base_index.gsub(':action', action.to_s).to_sym
          view_node.alias(action_index, new_index)
        end
      end

      protected

      def add_node(new_index, type, options={})
        view_node = SiteMap::ViewNode.new(*view_node_params(new_index, type, options))
        self.add_to_children(view_node)
        self.map.add_to_index(new_index, view_node) unless type == :group
        view_node
      end

    end

  end
end