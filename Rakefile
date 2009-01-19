require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'echoe'

Echoe.new('conventionally_scoped_names', '0.1.0') do |p|
  p.description    = "Access to scopes in controller, in a conventional way"
  p.url            = "http://github.com/eee-c/conventionally_scoped_names"
  p.author         = "Chris Strom"
  p.email          = "chris@eeecooks.com"
  p.ignore_pattern = ["tmp/*", "script/*"]
  p.development_dependencies = []
  p.test_pattern = "test/*_test.rb"
end

=begin

# Don't need this because of Echoe

desc 'Default: run unit tests.'
task :default => :test_conventionally_scoped_names

Rake::TestTask.new(:test_conventionally_scoped_names) do |t|
  t.libs << 'lib'
  t.pattern = 'test/*_test.rb'
  t.verbose = true
end

=end
