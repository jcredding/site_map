require File.join('site_map', 'helpers', 'mapping')
module SiteMap

  class ViewNode
    include SiteMap::Helpers::Mapping
    attr_reader :view_nodes, :type, :map
    attr_reader :index, :label, :url, :show, :parent_index

    def initialize(index, type, parent=nil, options={})
      @index = index
      @type = type
      options.each do |method, value|
        instance_variable_set("@#{method}", value)
      end
      @view_nodes = []
    end

    def parent
      @parent ||= self.map.index(self.parent_index) if self.parent_index
    end
    def ancestors
      unless @ancestors
        node, @ancestors = self, []
        @ancestors << node = node.parent while node.parent
      end
      @ancestors
    end
    def self_and_ancestors
      @with_ancestors ||= self.ancestors.dup.reverse.push(self)
    end
    def siblings
      @siblings ||= (self.self_and_siblings - self)
    end
    def self_and_siblings
      @with_siblings ||= self.parent.children
    end
    alias :children :view_nodes

  end

end