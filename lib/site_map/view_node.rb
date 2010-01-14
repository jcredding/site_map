require File.join('site_map', 'helpers', 'mapping')
module SiteMap

  class ViewNode
    include SiteMap::Helpers::Mapping
    ATTRIBUTES = [ :view_nodes, :map, :index, :label, :url, :show, :parent_index ]
    ATTRIBUTES.each{|attribute| attr_reader attribute }

    def initialize(index, map, options={})
      # raise error if no index or no map
      @index = index
      @map = map
      options.each do |method, value|
        instance_variable_set("@#{method}", value)
      end
      @view_nodes = []
    end

    def [](attribute_sym)
      instance_variable_get("@#{attribute_sym}")
    end

    def label
      @label ? @label : @index.to_s
    end
    def show
      @show ? @show : 'true'
    end
    def parent_index
      @parent_index.to_sym if @parent_index
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

    protected

    def view_node_params(new_index, options)
      @view_node_params ||= [new_index, self.map, options.merge(:parent_index => self.index)]
    end

  end

end