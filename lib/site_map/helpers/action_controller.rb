module SiteMap
  module Helpers

    module ActionController

      protected

      def view_node
        @view_node ||= SiteMap[[self.controller_name, self.action_name].join('__').to_sym]
      end

    end

  end
end