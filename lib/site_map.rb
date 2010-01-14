Dir[File.join(File.dirname(__FILE__), "site_map" ,"*.rb")].each do |file|
  require File.join('site_map', File.basename(file, ".rb"))
end

module SiteMap

  def self.setup
    single_file_path = File.join('config', 'site_map.rb')
    multiple_file_paths = Dir[File.join('config', 'site_map', '*.rb')].sort
    @@map ||= SiteMap::Map.new
    #clear out current nodes if any exist
    begin
      require single_file_path
    rescue LoadError => exception
      multiple_file_paths.each do |file_path|
        require file_path
      end
    end
  end

  def self.map
    @@map
  end

  def self.define(&block)
    yield @@map
  end

end
SiteMap.setup