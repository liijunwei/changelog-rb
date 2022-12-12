# frozen_string_literal: true
require "spec_helper"
require "yaml"

# TODO
RSpec.describe Changelog::Add do
  before { FileUtils.rm_rf("#{changelog_root}/unreleased") }

  let(:shell) { subject.shell }

  it "creates directory ./changelog/unreleased if it does not exist" do
    expect(File).not_to exist("#{changelog_root}/unreleased")

    shell.mute { subject.go("Something", nature: "Added", author: "someone") }

    expect(File).to exist("#{changelog_root}/unreleased")
  end

  it "generates the YAML file for the changelog item and add to ./changelog/unreleased" do
    shell.mute { subject.go("Added command for adding changelog item", nature: "Added", author: "someone") }

    expect(File).to exist("#{changelog_root}/unreleased/added_command_for_adding_changelog_item.yml")

    yaml = WorkaroundYAML.load_file("#{changelog_root}/unreleased/added_command_for_adding_changelog_item.yml")
    expect(yaml["type"]).to eq("Added")
    expect(yaml["title"]).to eq("Added command for adding changelog item\n")
    expect(yaml["author"]).to eq("someone")
  end

  it "raises error if title is blank" do
    expect(subject).to receive(:say) {|message| message}
    expect(shell.mute { subject.go("") }).to eq("Error: title is blank\nchangelog add TITLE\nchangelog add -g")
  end

  it "raises error if nature is not blank" do
    expect(subject).to receive(:say) {|message| message}
    expect(shell.mute { subject.go("I love changelog") }).to eq("Error: nature is blank\nchangelog add TITLE -t [#{Changelog.natures.join('|')}]")
  end

  it "raises error if nature is not defined" do
    expect(subject).to receive(:say) {|message| message}
    expect(shell.mute { subject.go("I love changelog", nature: "Modified") }).to eq("Error: nature is invalid\nchangelog add TITLE -t [#{Changelog.natures.join('|')}]")
  end

  it "raises error if author is blank" do
    ENV['USER'] = ""

    expect(subject).to receive(:say) {|message| message}
    expect(shell.mute { subject.go("Added command for adding changelog item", nature: 'Added') }).to eq("Error: author is blank\nchangelog add TITLE -u [author]")
  end
end
