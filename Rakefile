require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'sdoc'

# rake version:bump:major/minor/patch
# rake gemspec
begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "mirmaid_mir2disease"
    gem.summary = %Q{miR2Disease (http://www.mir2disease.org) plugin for MirMaid}
    gem.description = %Q{TODO}
    gem.email = "andersmbj@gmail.com"
    gem.homepage = "http://github.com/andersjacobsen/mirmaid_mir2disease"
    gem.authors = ["Anders Jacobsen"]
    # gem is a Gem::Specification... see
    # http://www.rubygems.org/read/chapter/20 for additional settings
  end

rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end


desc 'Default: run unit tests.'
task :default => :test

desc 'Test the mir2disease plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc 'Generate documentation for the mir2disease plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'MirMaid miR2Disease plugin'
  #  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.options << '--fmt' << 'shtml' # explictly set shtml generator
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
  rdoc.rdoc_files.include('app/**/*.rb')
end
