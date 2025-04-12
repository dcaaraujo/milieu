# frozen_string_literal: true

require "test_helper"

module Milieu
  class TestCLI < MilieuTest
    def setup
      @subject = Milieu::CLI
    end

    def test_version_prints_current_version
      assert_output(/#{Milieu::VERSION}/o) do
        @subject.start(["version"])
      end
    end

    def test_init_creates_a_milieu_folder
      Dir.mktmpdir do |dir|
        @subject.start(["init", dir, "--quiet"])
        Dir.chdir(dir) do
          assert Dir.exist?(".milieu")
          assert File.exist?(".milieu/.keep")
        end
      end
    end
  end
end
