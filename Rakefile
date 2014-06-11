require "bundler/setup"
require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new(:test) do |test|
  test.libs << "lib" << "test"
  test.test_files = FileList["test/*_test.rb"]
  test.verbose = true
  # test.warning = true
end

task :default => :test
