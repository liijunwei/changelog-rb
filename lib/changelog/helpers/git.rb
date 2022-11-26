# frozen_string_literal: true
module Changelog
  module Helpers
    class Git
      def self.tag(version)
        `git tag | grep "#{version}$"`.split("\n").first
      end
    end
  end
end
