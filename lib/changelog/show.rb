# frozen_string_literal: true
require "thor"
require "yaml"
require "changelog/helpers/changes"

module Changelog
  class Show < Thor
    include Thor::Actions
    include Changelog::Helpers::Changes

    no_commands do
      def go(version = nil)
        versions = version.nil? ? default_shown_versions : Array[version]

        versions.each do |version|
          print_version(version)
        end
      end

      private

      def print_version(version)
        if File.exist?("#{Changelog.configuration.versions_path}/#{version}")
          say version_header(version)
          say read_changes(version)
        else
          say "#{Changelog.configuration.versions_path}/#{version} not found"
        end
      end

      def default_shown_versions
        unreleased_version, latest_version = version_paths[0], version_paths[1]

        [unreleased_version, latest_version]
      end
    end
  end
end
