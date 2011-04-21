module SiteMap
  module Common

    module Tree
      attr_accessor :parent

      def views
        @views ||= []
      end

      def append(object)
        object.parent = self
        self.views.push(object)
      end

    end

  end
end
