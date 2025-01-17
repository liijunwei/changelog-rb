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

      TAG_FILE_REGEXP = Regexp.new("tag.yml")
      def changelog_files(folder)
        Dir["#{Changelog.configuration.versions_path}/#{folder}/*.yml"].grep_v(TAG_FILE_REGEXP)
      end

      def version_paths
        Dir.glob("*", base: Changelog.configuration.versions_path).reverse
      end
    end
  end
end
