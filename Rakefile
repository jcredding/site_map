require 'rubygems'
require 'rake/gempackagetask'
require 'rake/testtask'

require 'lib/site_map/version'

spec = Gem::Specification.new do |s|
  s.name             = 'site_map'
  s.version          = SiteMap::Version.to_s
  s.has_rdoc         = true
  s.extra_rdoc_files = %w(README.rdoc)
  s.rdoc_options     = %w(--main README.rdoc)
  s.summary          = "SiteMap provides a way to model out your site's views in a hierarchal fashion."
  s.author           = 'Collin Redding'
  s.email            = 'TempestTTU@gmail.com'
  s.homepage         = 'http://github.com/jcredding/site_map'
  s.files            = %w(README.rdoc Rakefile) + Dir.glob("{lib}/**/*")
  # s.executables    = ['site_map']

  s.add_development_dependency("shoulda", [">= 2.10.2"])
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = FileList["test/**/*_test.rb"]
  t.verbose = true
end

begin
  require 'rcov/rcovtask'

  Rcov::RcovTask.new(:coverage) do |t|
    t.libs       = ['test']
    t.test_files = FileList["test/**/*_test.rb"]
    t.verbose    = true
    t.rcov_opts  = ['--text-report', "-x #{Gem.path}", '-x /Library/Ruby', '-x /usr/lib/ruby']
  end

  task :default => :coverage

rescue LoadError
  warn "\n**** Install rcov (sudo gem install relevance-rcov) to get coverage stats ****\n"
  task :default => :test
end


desc 'Generate the gemspec to serve this gem'
task :gemspec do
  file = File.dirname(__FILE__) + "/#{spec.name}.gemspec"
  File.open(file, 'w') {|f| f << spec.to_ruby }
  puts "Created gemspec: #{file}"
end

task :environment do
  require File.join(File.dirname(__FILE__), 'test', 'test_helper.rb')
  files_path = File.expand_path(File.join(File.dirname(__FILE__), 'test', 'support', 'config', 'site_map', '*.rb'))
  files = Dir[files_path].sort
  SiteMap.setup(files)
end

load File.join(File.dirname(__FILE__), 'lib', 'site_map', 'tasks', 'view_nodes.rake')
