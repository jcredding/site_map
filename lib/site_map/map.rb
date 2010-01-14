require File.join('site_map', 'helpers', 'mapping')
module SiteMap

  class Map
    include SiteMap::Helpers::Mapping
    ATTRIBUTES = [:view_nodes, :index_of_nodes]
    ATTRIBUTES.each{|attribute| attr_reader attribute }

    def initialize
      self.clear_nodes!
    end

    def find(view_node_index)
      self.index_of_nodes[view_node_index.to_sym]
    end

    def add_to_children(view_node)
      @view_nodes.push(view_node)
    end
    def add_to_index(view_node)
      @index_of_nodes[view_node.index.to_sym] = view_node
    end

    def clear_nodes!
      @view_nodes = []
      @index_of_nodes = {}
    end

    # convenience method
    def map
      self
    end

    protected

    def view_node_params(index, options)
      [index, self, options]
    end

  end

end