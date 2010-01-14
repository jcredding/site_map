Dir[File.join(File.dirname(__FILE__), "site_map" ,"*.rb")].each do |file|
  require File.join('site_map', File.basename(file, ".rb"))
end

module SiteMap

  def self.setup(*files)
    files = files.first if files.first.is_a?(Array)
    files << File.join('config', 'site_map.rb') if files.empty?
    @@map ||= SiteMap::Map.new
    @@map.clear_nodes!
    files.each do |file|
      begin
        load file
      rescue LoadError => exception
        puts "couldn't find file #{file} to load, no site map configuration loaded"
      end
    end
  end

  def self.[](view_node_index)
    self.map.find(view_node_index.to_sym)
  end

  def self.view_nodes
    self.map.view_nodes
  end

  def self.map
    @@map
  end

  def self.define(&block)
    yield @@map
  end

end
SiteMap.setup