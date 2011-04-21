require 'site_map/common/tree'

module SiteMap
  class View
    include SiteMap::Common::Tree

    attr_accessor :key, :label, :url, :visible

    def initialize(key)
      self.key = key
    end

  end
end
