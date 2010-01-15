# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{site_map}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Collin Redding"]
  s.date = %q{2010-01-15}
  s.email = %q{TempestTTU@gmail.com}
  s.extra_rdoc_files = ["README.rdoc"]
  s.files = ["README.rdoc", "Rakefile", "lib/site_map", "lib/site_map/helpers", "lib/site_map/helpers/mapping.rb", "lib/site_map/helpers.rb", "lib/site_map/map.rb", "lib/site_map/version.rb", "lib/site_map/view_helpers", "lib/site_map/view_node.rb", "lib/site_map.rb"]
  s.homepage = %q{http://github.com/jcredding/site_map}
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{This gem does ...}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
