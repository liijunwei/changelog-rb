# frozen_string_literal: true
require "thor"
require "changelog-rb"

module Changelog
  class CLI < Thor
    include Thor::Actions

    package_name "changelog"

    desc "version", "Show current version"
    def version
      say Changelog::VERSION
    end

    desc "setup", "Set up changelog folder structure"
    def setup
      Changelog::Setup.new.go
    end

    desc "add [TITLE]", "Add a new changelog item"
    method_option :nature,
      type: :string,
      desc: "Type of changes. Default: Derive from first word of TITLE",
      enum: Changelog.natures,
      aliases: %w(--type -t)
    method_option :author,
      type: :string,
      desc: "User who makes the changes. Default: $USER",
      aliases: %w(--user -u)
    method_option :git,
      type: :string,
      desc: "Extracts the title from git commit comment. Default: HEAD",
      aliases: %w(-g)
    def add(title = "")
      Changelog::Add.new.go(title, **options.to_hash.symbolize_keys)
    end

    desc "tag VERSION", "Tag the unreleased changes to a version"
    method_option :date,
      type: :string,
      desc: "Date of release. Default: Today",
      aliases: %w(-d)
    def tag(version)
      Changelog::Tag.new.go(version, **options.to_hash.symbolize_keys)
    end

    desc "untag VERSION", "Moved the changes from version folder to unreleased"
    def untag(version)
      Changelog::Untag.new.go(version)
    end

    desc "show VERSION", "Print changes of VERSION, default show unreleased and latest"
    def show(version = nil)
      Changelog::Show.new.go(version)
    end

    desc "print", "Print ./changelog to CHANGELOG.md"
    def print
      Changelog::Print.new.go
    end
  end
end
