require 'site_map/map'
require 'site_map/group'
require 'site_map/view'

module SiteMap
  class Builder
    attr_accessor :map, :context

    def initialize
      self.map = SiteMap::Map.new
      self.context = self.map
    end

    def build(&block)
      self.instance_eval(&block)
      SiteMap.map = self.map
    end

    def view(key, &block)
      parent = self.context                 # store the current context
      view = SiteMap::View.new(key)         # TODO needs to set defaults based on the key
      self.continue_build(view, &block)
      parent.append(view)                   # add the view to the tree
      self.map.index(view)                  # index the view in the map
      self.context = parent                 # reset the context
    end

    # don't index groups in the map
    def group(key, &block)
      parent = self.context
      group = SiteMap::Group.new(key)
      self.continue_build(group, &block)
      parent.append(group)
      self.context = parent
    end

    # if self.context !!!!!
    def label(value)
      self.context.label = value
    end
    def visible(value)
      self.context.visible = value
    end
    def url(value)
      self.context.url = value
    end

    protected

    def continue_build(object, &block)
      self.context = object
      self.instance_eval(&block) if block
    end

  end
end
