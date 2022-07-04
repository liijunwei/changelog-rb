# frozen_string_literal: true
module Changelog
  module Helpers
    class Shell
      def self.system_user
        ENV["USER"]
      end
    end
  end
end
