require File.join('site_map', 'helpers', 'mapping')
module SiteMap

  class Map
    include SiteMap::Helpers::Mapping
    attr_reader :view_nodes

    def initialize
      @view_nodes = []
      @index_of_nodes = {}
    end

    def index(view_node_index)
      self.index_of_nodes[view_node_index]
    end

    def add_to_index(view_node)
      @index_of_nodes[view_node.index.to_sym] = view_node
    end

    # convenience method
    def map
      self
    end

    protected

    def view_node_params(index, options)
      @view_node_params ||= [index, self, options]
    end

  end

end