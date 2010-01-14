Dir[File.join(File.dirname(__FILE__), "helpers" ,"*.rb")].each do |file|
  require File.join('site_map', 'helpers', File.basename(file, ".rb"))
end