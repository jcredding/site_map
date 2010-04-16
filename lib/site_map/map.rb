require File.join('site_map', 'helpers', 'mapping')
module SiteMap

  class Map
    include SiteMap::Helpers::Mapping
    ATTRIBUTES = [:view_nodes, :index_of_nodes]
    ATTRIBUTES.each{|attribute| attr_reader attribute }
    alias_method :views, :view_nodes

    def initialize
      self.clear_nodes!
    end

    def find(view_node_index)
      self.index_of_nodes[view_node_index.to_sym]
    end

    def add_to_children(view_node)
      @view_nodes.push(view_node)
    end
    def add_to_index(index, view_node)
      @index_of_nodes[index.to_sym] = view_node
    end

    def clear_nodes!
      @view_nodes = []
      @index_of_nodes = {}
    end

    # convenience method
    def map
      self
    end

    def inspect
      "#<#{self.class}>"
    end
    
    def visible_views
      @view_nodes.select do |view|
        view.visible?
      end
    end

    protected

    def view_node_params(index, node_type, options)
      [index, self, node_type, options]
    end

  end

end