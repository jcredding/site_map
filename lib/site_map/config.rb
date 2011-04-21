require 'pathname'

module SiteMap
  class Config
    attr_writer :definition_file

    def definition_file
      @definition_file ||= if self.rails?
        Rails.root.join(self.default_file_path)
      else
        Pathname.new(self.default_file_path)
      end
    end

    protected

    def rails?
      defined?(::Rails)
    end

    def default_file_path
      File.join("config", "site_map.rb")
    end

  end
end
