require File.join('site_map', 'helpers', 'mapping')
module SiteMap

  class Map
    include SiteMap::Helpers::Mapping
    attr_reader :view_nodes

    def initialize
      @view_nodes = []
    end

    def index(index)
    end

  end

end