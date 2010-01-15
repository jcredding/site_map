module SiteMap
  module ViewHelpers

    # Override in view scope to resolve against your labels
    def view_node_label_options
      {}
    end

    # subbing hash options into view node label code thanks to kelredd-useful
    def view_node_label(view_node)
      label_string = view_node.label
      view_node_label_options.each do |label_key, value|
        label_string.gsub!(":#{label_key}", value.to_s)
      end
      label_string
    end
    def view_node_url(view_node)
      eval(view_node.url)
    end
    def view_node_visible(view_node)
      eval(view_node.visible)
    end
    alias :view_node_visible? :view_node_visible

  end
end