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
      self.map.index(self.parent_index) if self.parent_index
    end
    alias :children :view_nodes

  end

end