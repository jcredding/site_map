require File.join('site_map', 'helpers', 'mapping')
module SiteMap

  class ViewNode
    include SiteMap::Helpers::Mapping
    ATTRIBUTES = [ :map, :index, :label, :url, :visible, :resource, :parent, :type ]
    ATTRIBUTES.each{|attribute| attr_reader attribute }

    TYPES = [ :view, :group, :member, :collection ]
    LABEL_ACTION_TEMPLATES = {
      :index => ":resource List",
      :new => "New :resource",
      :show => "::resource_name",
      :edit => "Edit ::resource_name"
    }
    URL_ACTION_TEMPLATES = {
      :index => ":resource_path",
      :new => "new_:resource_path",
      :show => ":resource_path(@:resource)",
      :edit => "edit_:resource_path(@:resource)"
    }

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
      @label ? @label : self.default_label
    end
    def url
      @url ? @url : self.default_url
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

    def default_label
      case(@type)
      when :group
        self.titled_index
      when :collection
        LABEL_ACTION_TEMPLATES[@action].gsub(':resource', (@action == :new ? self.single_resource : self.titled_resource))
      when :member
        LABEL_ACTION_TEMPLATES[@action].gsub(':resource', self.single_resource)
      else
        @index.to_s
      end
    end
    def default_url
      case(@type)
      when :group
        self.children.empty? ? @url : self.children.first.url
      when :collection
        URL_ACTION_TEMPLATES[@action].gsub(':resource', (@action == :new ? self.single_resource : @resource.to_s))
      when :member
        URL_ACTION_TEMPLATES[@action].gsub(':resource', self.single_resource)
      else
        @url
      end
    end

    def titled_index
      @titled_index ||= @index.to_s.respond_to?(:titleize) ? @index.to_s.titleize : @index.to_s
    end
    def single_resource
      @single_resource ||= @resource.to_s.respond_to?(:singularize) ? @resource.to_s.singularize : @resource.to_s
    end
    def titled_resource
      @titled_resource ||= @resource.to_s.respond_to?(:titleize) ? @resource.to_s.titleize : @resource.to_s
    end

    def view_node_params(new_index, type, options)
      [new_index, self.map, type, options.merge(:parent => self)]
    end

  end

end