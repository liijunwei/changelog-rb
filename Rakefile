# frozen_string_literal: true
require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

desc 'Run RSpec with code coverage'
task :coverage do
  ENV['COVERAGE'] = 'true'
  Rake::Task['spec'].execute
  sh "open coverage/index.html" rescue nil
end

desc "check code quality with flog"
task :flog do
  system "find lib -name \*.rb | xargs flog"
end

desc "check code quality with flay"
task :flay do
  system "flay lib/*.rb"
end

task default: :spec
