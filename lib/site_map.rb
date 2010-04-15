Dir[File.join(File.dirname(__FILE__), "site_map" ,"*.rb")].each do |file|
  unless ['tasks', 'version'].include?(File.basename(file, ".rb"))
    require File.join('site_map', File.basename(file, ".rb"))
  end
end

module SiteMap

  DEFAULT_FILE = File.join('config', 'site_map.rb')

  class << self
    
    def setup(*files)
      files = files.first if files.first.is_a?(Array)
      files << DEFAULT_FILE if files.empty?
      self.logger = Rails.logger if defined?(Rails)
      @@map ||= SiteMap::Map.new
      @@map.clear_nodes!
      files.each do |file|
        begin
          load file
        rescue LoadError => exception
          self.logger.info("SiteMap config file: #{file} could not be loaded.") unless file == DEFAULT_FILE
        end
      end
    end

    def [](view_node_index)
      self.map.find(view_node_index.to_sym)
    end

    def view_nodes
      self.map.view_nodes
    end
    alias_method :views, :view_nodes

    def map
      @@map
    end

    def define(&block)
      yield @@map
    end

    def logger
      @@logger ||= Logger.new(STDOUT)
    end
    def logger=(new_logger)
      @@logger = new_logger
    end

  end

end
SiteMap.setup

ActionView::Base.send(:include, SiteMap::ViewHelpers) if defined?(ActionView::Base)
ActionController::Base.send(:include, SiteMap::Helpers::ActionController) if defined?(ActionController::Base)