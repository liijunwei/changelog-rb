# frozen_string_literal: true
module PathHelpers
  def changelog_root
    Changelog.configuration.versions_path
  end

  def changelog_summary
    Changelog.configuration.summary_path
  end
end
