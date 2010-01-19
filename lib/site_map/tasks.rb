Dir[File.join(File.dirname(__FILE__), "tasks" ,"*.rake")].each do |file|
  load File.join('site_map', 'tasks', File.basename(file))
end