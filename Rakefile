#!/usr/bin/env rake
require "bundler/gem_tasks"
task :test do
     require 'rake/testtask'
     Rake::TestTask.new do |t|
       t.libs << 'test'
       t.test_files = FileList['test/**/tc_*.rb']
       t.verbose = false
       t.warning = true
     end
end

task :default => :test
