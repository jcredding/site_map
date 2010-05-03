# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{site_map}
  s.version = "0.3.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Collin Redding"]
  s.date = %q{2010-05-03}
  s.email = %q{TempestTTU@gmail.com}
  s.extra_rdoc_files = ["README.rdoc"]
  s.files = ["README.rdoc", "Rakefile", "lib/site_map", "lib/site_map/exceptions.rb", "lib/site_map/helpers", "lib/site_map/helpers/action_controller.rb", "lib/site_map/helpers/mapping.rb", "lib/site_map/helpers.rb", "lib/site_map/map.rb", "lib/site_map/tasks", "lib/site_map/tasks/view_nodes.rake", "lib/site_map/tasks.rb", "lib/site_map/version.rb", "lib/site_map/view_helpers.rb", "lib/site_map/view_node.rb", "lib/site_map.rb"]
  s.homepage = %q{http://github.com/jcredding/site_map}
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{SiteMap provides a way to model out your site's views in a hierarchal fashion.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<shoulda>, [">= 2.10.2"])
    else
      s.add_dependency(%q<shoulda>, [">= 2.10.2"])
    end
  else
    s.add_dependency(%q<shoulda>, [">= 2.10.2"])
  end
end
