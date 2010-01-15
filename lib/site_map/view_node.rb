require File.join('site_map', 'helpers', 'mapping')
module SiteMap

  class ViewNode
    include SiteMap::Helpers::Mapping
    ATTRIBUTES = [ :map, :index, :label, :url, :visible, :parent, :type ]
    ATTRIBUTES.each{|attribute| attr_reader attribute }

    TYPES = [ :view, :group ]

    def initialize(index, map, type, options={})
      raise(ArgumentError, "index, map and type arguements required") unless index && map && type
      @index = index
      @map = map
      @type = type
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
    def url
      if !@url && self.group?
        self.children.empty? ? @url : self.children.first.url
      else
        @url
      end
    end
    def visible
      @visible ? @visible : 'true'
    end

    def add_to_children(view_node)
      @view_nodes.push(view_node)
    end

    def children
      @view_nodes
    end
    def ancestors
      unless @ancestors
        node, @ancestors = self, []
        @ancestors << node = node.parent while node.parent
        @ancestors.reverse!
      end
      @ancestors
    end
    def self_and_ancestors
      @with_ancestors ||= self.ancestors.dup.push(self)
    end
    def siblings
      @siblings ||= (self.self_and_siblings - [self])
    end
    def self_and_siblings
      @with_siblings ||= self.parent.children
    end

    TYPES.each do |type|
      self.send(:define_method, "#{type}?", lambda{ self.type == type })
    end

    def inspect
      attributes_string = [:index, :type, :label, :url, :visible].collect do |attribute|
        "#{attribute}: #{self.send(attribute).inspect}"
      end.join(", ")
      "#<#{self.class} #{attributes_string}>"
    end

    protected

    def view_node_params(new_index, type, options)
      [new_index, self.map, type, options.merge(:parent => self)]
    end

  end

end