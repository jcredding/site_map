module SiteMap
  module Helpers

    module ActionController

      def self.included(base)
        if base.respond_to?(:helper_method)
          base.send(:helper_method, :view_node)
        end
      end

      protected

      def view_node
        @view_node ||= SiteMap[[self.controller_name, self.action_name].join('__').to_sym]
      end

    end

  end
end