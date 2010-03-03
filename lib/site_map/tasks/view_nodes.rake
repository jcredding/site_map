namespace :site_map do

  desc 'Print out all defined view nodes based on the current SiteMap configuration'
  task :nodes => :environment do
    index_length = SiteMap.map.index_of_nodes.collect{|key, value| key.inspect.length}.max + 1
    index_length += (SiteMap.map.index_of_nodes.collect{|key, value| value.ancestors.size}.max * 2)
    label_length = SiteMap.map.index_of_nodes.collect{|key, value| value.label.inspect.length}.max
    url_length = SiteMap.map.index_of_nodes.collect{|key, value| value.url.inspect.length}.max
    options = {
      :spacing => 0,
      :index_length => index_length,
      :label_length => label_length,
      :url_length => url_length
    }
    display_header(options)
    display_view_nodes(SiteMap.view_nodes, options)
    print "\n * - denotes an that this index is an alias of the previous node (that isn't an alias)"
    print "\n indentation denotes children nodes"
    print "\n\n"
  end

  def display_view_nodes(view_nodes, options={})
    view_nodes.each do |view_node|
      display_view_node(view_node, view_node.index, options)
      view_node.aliases.each do |alias_key|
        display_view_node(view_node, alias_key, options)
      end
      display_view_nodes(view_node.children, options.merge(:spacing => (options[:spacing] + 2)))
    end
  end

  def display_view_node(view_node, key=nil, options={})
    key ||= view_node.index
    print "#{(' ' * options[:spacing])}#{key.inspect}#{'*' if key != view_node.index}".ljust(options[:index_length])
    print " | "
    print "#{view_node.label.inspect.ljust(options[:label_length])}"
    print " | "
    print "#{view_node.url.inspect.ljust(options[:url_length])}"
    print " | "
    print "#{view_node.visible.inspect}"
    print "\n"
  end

  def display_header(options={})
    print "Node Index".ljust(options[:index_length])
    print " | "
    print "Label".ljust(options[:label_length])
    print " | "
    print "URL".ljust(options[:url_length])
    print " | "
    print "Visible"
    print "\n"
  end
end
