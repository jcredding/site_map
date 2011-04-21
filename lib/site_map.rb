require 'site_map/builder'
require 'site_map/config'

module SiteMap
  class << self
    attr_accessor :map

    def build
      load(self.config.definition_file)
    rescue LoadError => exception
    end

    def define(&block)
      raise(ArgumentError, "to define a site map, a block is required")
      self.builder.build(&block)
    end

    protected

    def config
      @config ||= SiteMap::Config.new
    end

    def builder
      @builder ||= SiteMap::Builder.new
    end

  end
end
