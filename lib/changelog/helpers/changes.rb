# frozen_string_literal: true
require "yaml"
require "semantic"
require 'semantic/core_ext'

module Changelog
  module Helpers
    module Changes
      def version_header(folder)
        if folder == "unreleased"
          "## [#{version_text(folder)}]\n"
        else
          meta = WorkaroundYAML.load_file("#{Changelog.configuration.versions_path}/#{folder}/tag.yml")
          date = meta["date"].to_s
          "## [#{version_text(folder)}] - #{date}\n"
        end
      end

      def version_text(folder)
        if folder == "unreleased"
          "Unreleased"
        else
          folder
        end
      end

      def read_changes(folder)
        items = {}
        changelog_files(folder).each do |file|
          yaml = WorkaroundYAML.load_file(file)
          items[yaml["type"]] ||= []
          items[yaml["type"]] << "#{yaml['title'].strip} (@#{yaml['author']})"
        end

        sections = []
        items.keys.sort.each do |nature|
          lines = []
          lines << "### #{nature}\n"
          items[nature].sort.each { |change| lines << "- #{change}\n" }

          sections << lines.join("")
        end

        sections.join("\n")
      end

      def changelog_files(folder)
        Dir["#{Changelog.configuration.versions_path}/#{folder}/*.yml"].grep_v(/\/tag.yml/)
      end

      def version_folders
        version_paths.map { |path| File.basename(path).to_version }.sort.reverse.map(&:to_s)
      end

      def version_paths
        paths = Dir["#{Changelog.configuration.versions_path}/*"]
        paths.delete("#{Changelog.configuration.versions_path}/unreleased")

        paths
      end

      def latest_version
        version_folders.first
      end
    end
  end
end
