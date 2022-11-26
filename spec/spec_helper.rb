# frozen_string_literal: true

if ENV.fetch('COVERAGE', 'f').start_with? 't'
  require 'simplecov'
  SimpleCov.start
end

require "bundler/setup"
require "pry"
require "changelog-rb"

require_relative "support/md5sum_helpers"
require_relative "support/path_helpers"

def setup_git_repo(sandbox_root)
  `git -C #{sandbox_root} init`
  `git -C #{sandbox_root} remote add origin git@github.com:username/repo.git`
  `git -C #{sandbox_root} add .`
  `git -C #{sandbox_root} commit -am "Init sandbox git repo"`
end

RSpec.configure do |config|
  config.example_status_persistence_file_path = ".rspec_status"
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.include PathHelpers
  config.include Md5sumHelpers

  sandbox_root = "spec/sandbox"

  config.around :each do |example|
    Changelog.configure do |config|
      config.versions_path = "#{sandbox_root}/changelog"
      config.summary_path  = "#{sandbox_root}/CHANGELOG.md"
    end

    FileUtils.mkdir_p sandbox_root

    setup_git_repo(sandbox_root)

    example.run

    FileUtils.rm_rf sandbox_root
  end
end
