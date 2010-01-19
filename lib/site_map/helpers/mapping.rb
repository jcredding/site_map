module SiteMap
  module Helpers

    module Mapping

      DEFAULT_ALIAS = {
        :index => [:new, :create],
        :new => [:create],
        :show => [:edit, :update, :destroy],
        :edit => [:update]
      }

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
        view_node = self.collection_view(resource, :index, options)
        yield view_node if block_given?
      end
      def collection_view(resource, action, options={})
        options.merge!({:resource => resource.to_sym, :action => action.to_sym})
        view_node = self.add_node([resource, action].join('__').to_sym, :collection, options)
        (DEFAULT_ALIAS[action] || []).each do |action|
          view_node.alias([resource, action].join('__').to_sym, view_node.index)
        end
        block_given? ? (yield view_node) : view_node
      end
      def member(resource, options={})
        view_node = self.member_view(resource, :show, options)
        yield view_node if block_given?
      end
      def member_view(resource, action, options={})
        options.merge!({:resource => resource.to_sym, :action => action.to_sym})
        view_node = self.add_node([resource, action].join('__').to_sym, :member, options)
        (DEFAULT_ALIAS[action] || []).each do |action|
          view_node.alias([resource, action].join('__').to_sym, view_node.index)
        end
        block_given? ? (yield view_node) : view_node
      end

      protected

      def add_node(new_index, node_type, options={})
        view_node = SiteMap::ViewNode.new(*view_node_params(new_index, node_type, options))
        self.add_to_children(view_node)
        self.map.add_to_index(new_index, view_node) unless node_type == :group
        view_node
      end

    end

  end
end