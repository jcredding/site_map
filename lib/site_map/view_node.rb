require File.join('site_map', 'helpers', 'mapping')
module SiteMap

  class ViewNode
    include SiteMap::Helpers::Mapping
    ATTRIBUTES = [ :map, :index, :label, :url, :visible, :resource, :parent, :type ]
    ATTRIBUTES.each{|attribute| attr_reader attribute }

    TYPES = [ :view, :group, :member, :collection ]
    BASE_LABEL_TEMPLATE = {
      :collection => ":action :resource",
      :member => ":action ::resource_name"
    }
    LABEL_ACTION_TEMPLATES = {
      :index => BASE_LABEL_TEMPLATE[:collection].gsub(':action','').strip,
      :show => BASE_LABEL_TEMPLATE[:member].gsub(':action','').strip
    }
    BASE_URL_TEMPLATE = {
      :collection => [':resource', 'path'],
      :member => [':resource', 'path(@:resource)']
    }
    URL_ACTION_TEMPLATES = {
      :index => BASE_URL_TEMPLATE[:collection],
      :show => BASE_URL_TEMPLATE[:member]
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
        self.title_string(@index)
      when :collection
        self.resource_label((@action == :new ? self.single_string : self.title_string))
      when :member
        self.resource_label(self.single_string)
      else
        @index.to_s
      end
    end
    def default_url
      case(@type)
      when :group
        self.children.empty? ? @url : self.children.first.url
      when :collection
        self.resource_url
      when :member
        self.resource_url
      else
        @url
      end
    end

    def resource_label(resource_text)
      template = (LABEL_ACTION_TEMPLATES[@action] || BASE_LABEL_TEMPLATE[@type])
      template.gsub(':action', self.title_string(@action.to_s)).gsub(':resource', resource_text)
    end
    def resource_url
      resource_text = if @type == :collection
        action_str = unless URL_ACTION_TEMPLATES[@action]
          @action.to_s
        end
        parent_str = if [:member, :collection].include?(self.parent.type)
          self.single_string(self.parent.resource)
        elsif self.parent.type == :group
          self.parent.index.to_s
        end
        template = (URL_ACTION_TEMPLATES[@action] || BASE_URL_TEMPLATE[@type])
        resourced_url = [action_str, parent_str, template].flatten.compact.join('_')
        resourced_url = [resourced_url, ("(@#{parent_str})" if parent_str)].compact.join
        resourced_url.gsub(':resource', (@action == :new ? self.single_string : @resource.to_s))
      else
        action_str = unless URL_ACTION_TEMPLATES[@action]
          @action.to_s
        end
        template = (URL_ACTION_TEMPLATES[@action] || BASE_URL_TEMPLATE[@type])
        resourced_url = [action_str, template].flatten.compact.join('_')
        resourced_url.gsub(':resource', self.single_string)
      end
    end

    def single_string(string = nil)
      string ||= @resource
      string.to_s.respond_to?(:singularize) ? string.to_s.singularize : string.to_s
    end
    def title_string(string = nil)
      string ||= @resource
      string.to_s.respond_to?(:titleize) ? string.to_s.titleize : string.to_s
    end

    def view_node_params(new_index, type, options)
      [new_index, self.map, type, options.merge(:parent => self)]
    end

  end

end