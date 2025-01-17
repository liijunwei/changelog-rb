# frozen_string_literal: true
require "thor"

module Changelog
  class Add < Thor
    include Thor::Actions

    def self.source_root
      File.expand_path("../templates", __dir__)
    end

    no_commands do
      def go(title, nature: "", author: "")
        @title = title.gsub(/:\w+:/, "")
        @nature = nature.presence
        @author = author.presence

        if @title.blank?
          return say("Error: title is blank\nchangelog add TITLE\nchangelog add -g")
        end
        if @nature.blank?
          return say("Error: nature is blank\nchangelog add TITLE -t [#{Changelog.natures.join('|')}]")
        end
        unless @nature.in?(Changelog.natures)
          return say("Error: nature is invalid\nchangelog add TITLE -t [#{Changelog.natures.join('|')}]")
        end
        if @author.blank?
          return say("Error: author is blank\nchangelog add TITLE -u [author]")
        end

        filename = @title.parameterize.underscore

        empty_directory "#{Changelog.configuration.versions_path}/unreleased" unless File.exists?("#{Changelog.configuration.versions_path}/unreleased")
        template "item.yml", "#{Changelog.configuration.versions_path}/unreleased/#{filename}.yml"

        true
      end
    end
  end
end
