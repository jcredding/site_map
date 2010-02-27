require File.join('site_map', 'helpers', 'mapping')
module SiteMap

  class ViewNode
    include SiteMap::Helpers::Mapping
    ATTRIBUTES = [ :map, :index, :label, :url, :visible, :resource, :parent, :node_type ]
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

    def initialize(index, map, node_type, options={})
      raise(ArgumentError, "index, map and node_type arguements required") unless index && map && node_type
      @index = index
      @map = map
      @node_type = node_type
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

    def aliases
      @aliases ||= self.map.index_of_nodes.collect do |key, view_node|
        key if view_node.index == self.index && key != self.index
      end.compact
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

    TYPES.each do |node_type|
      self.send(:define_method, "#{node_type}?", lambda{ self.node_type == node_type })
    end

    def inspect
      attributes_string = [:index, :node_type, :label, :url, :visible].collect do |attribute|
        "#{attribute}: #{self.send(attribute).inspect}"
      end.join(", ")
      "#<#{self.class} #{attributes_string}>"
    end

    protected

    def default_label
      case(@node_type)
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
      case(@node_type)
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
      template = (LABEL_ACTION_TEMPLATES[@action] || BASE_LABEL_TEMPLATE[@node_type])
      template.gsub(':action', self.title_string(@action.to_s)).gsub(':resource', resource_text)
    end
    def resource_url
      resource_text = if @node_type == :collection
        action_str = unless URL_ACTION_TEMPLATES[@action]
          @action.to_s
        end
        parent_str = if self.parent && [:member, :collection].include?(self.parent.node_type)
          self.single_string(self.parent.resource)
        end
        template = (URL_ACTION_TEMPLATES[@action] || BASE_URL_TEMPLATE[@node_type])
        resourced_url = [action_str, parent_str, template].flatten.compact.join('_')
        resourced_url = [resourced_url, ("(@#{parent_str})" if parent_str)].compact.join
        resourced_url.gsub(':resource', (@action == :new ? self.single_string : @resource.to_s))
      else
        action_str = unless URL_ACTION_TEMPLATES[@action]
          @action.to_s
        end
        template = (URL_ACTION_TEMPLATES[@action] || BASE_URL_TEMPLATE[@node_type])
        resourced_url = [action_str, template].flatten.compact.join('_')
        resourced_url.gsub(':resource', self.single_string)
      end
    end

    def single_string(string = @resource)
      self.format_string(string, :singularize)
    end
    def title_string(string = @resource)
      self.format_string(string, :titleize)
    end

    def view_node_params(new_index, node_type, options)
      [new_index, self.map, node_type, options.merge(:parent => self)]
    end

    def format_string(string, format)
      string.to_s.respond_to?(format) ? string.to_s.send(format) : string.to_s
    end

  end

end