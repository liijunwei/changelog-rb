# frozen_string_literal: true
require "thor"
require "yaml"
require "semantic"
require "changelog/helpers/changes"

module Changelog
  class Print < Thor
    include Thor::Actions
    include Changelog::Helpers::Changes

    no_commands do
      def go
        remove_file Changelog.configuration.summary_path
        add_file Changelog.configuration.summary_path

        append_to_file Changelog.configuration.summary_path, "# Changelog\n", verbose: false

        versions = %w[unreleased].concat(version_folders)

        versions.each do |version|
          shell.say_status :append, "changes in #{Changelog.configuration.versions_path}/#{version}", :green unless shell.mute?
          print_version_header version
          print_changes version
        end
      end

      def print_version_header(folder)
        append_to_file Changelog.configuration.summary_path, "\n", verbose: false, force: true
        append_to_file Changelog.configuration.summary_path, version_header(folder), verbose: false
      end

      def print_changes(folder)
        append_to_file Changelog.configuration.summary_path, read_changes(folder), verbose: false, force: true
      end
    end
  end
end
