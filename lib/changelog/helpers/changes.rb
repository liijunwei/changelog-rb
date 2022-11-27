# frozen_string_literal: true
require "yaml"

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

      # TODO refactor this mess...
      def version_folders
        (Dir[File.join(destination_root, "#{Changelog.configuration.versions_path}/*")] - [
          File.join(destination_root, "#{Changelog.configuration.versions_path}/unreleased")
        ]).map {|path| File.basename(path)}.sort_by {|version|
          if version.match Semantic::Version::SemVerRegexp
            Semantic::Version.new(version)
          elsif version.match /\A(0|[1-9]\d*)\.(0|[1-9]\d*)\Z/
            # Example: 0.3, 1.5, convert it to 0.3.0, 1.5.0
            Semantic::Version.new("#{version}.0")
          end
        }.reverse
      end

      def latest_version
        version_folders.first
      end
    end
  end
end
