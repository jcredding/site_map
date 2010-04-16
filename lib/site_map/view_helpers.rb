module SiteMap
  module ViewHelpers

    # Override in view scope to resolve against your labels
    def view_node_label_options
      {}
    end

    # subbing hash options into view node label, code thanks to kelredd-useful
    def view_node_label(view_node)
      label_string = view_node.label.dup
      view_node_label_options.each do |label_key, value|
        label_string.gsub!(":#{label_key}", value.to_s)
      end
      label_string
    end
    def view_node_url(view_node)
      eval(view_node.url)
    end
    def view_node_visible(view_node)
      eval(view_node.visible.to_s)
    end
    alias :view_node_visible? :view_node_visible

    def display_title(options = {})
      self.display_joined_view_nodes([@view_node.parent, @view_node], options.merge({
        :html => false
      }))
    end
    def display_crumbs(options = {})
      options[:html] ||= {:class => "breadcrumb"}
      self.display_joined_view_nodes(@view_node.self_and_ancestors, options)
    end
    def display_menu

    end

    def display_joined_view_nodes(view_nodes, options = {})
      options = {
        :connector => " > ",
        :html => true
      }.merge(options)
      display_view_nodes = view_nodes.collect do |view_node|
        if options[:html]
          html_options = options[:html].kind_of?(::Hash) ? options[:html] : {}
          content_tag(:a, view_node_label(view_node), html_options.merge({
            :href => view_node_url(view_node)
          }))
        else
          view_node_label(view_node)
        end
      end
      display_connector = if options[:html]
        content_tag(:span, options[:connector])
      else
        options[:connector]
      end
      display_view_nodes.join(display_connector)
    end

  end
end
