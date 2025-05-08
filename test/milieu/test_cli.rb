# frozen_string_literal: true

require "test_helper"
require "milieu/cli"

module Milieu
  class TestCLI < MilieuTest
    def setup
      @subject = Milieu::CLI
    end

    def test_should_exit_on_failure
      assert Milieu::CLI.exit_on_failure?
    end

    def test_version_prints_current_version
      assert_output(/#{Milieu::VERSION}/o) do
        @subject.start(["version"])
      end
    end

    def test_init_creates_a_milieu_folder
      Dir.mktmpdir do |dir|
        @subject.start(["init", dir, "--quiet"])
        assert Dir.exist?("#{dir}/.milieu")
      end
    end

    def test_init_creates_a_schema_file
      Dir.mktmpdir do |dir|
        @subject.start(["init", dir, "--quiet"])
        assert File.exist?(schema_file_path(dir))
      end
    end

    def test_setup_exports_env_file
      Dir.mktmpdir do |dir|
        @subject.start(["init", dir, "--quiet"])
        schema = Milieu::Schema.create(version: 0) do
          define_env_variable("EXAMPLE1", "An example env variable")
          define_env_variable("EXAMPLE2", "A second example env variable")
          define_env_variable("EXAMPLE3", 3)
        end

        File.open(schema_file_path(dir), "w") do |file|
          file.puts Milieu::SchemaExporter.new(schema).export.join("\n")
        end

        @subject.start(["setup", dir, "--quiet"])
        assert File.exist?(env_file(dir))
      end
    end

    private

    def schema_file_path(dir)
      File.join(dir, ".milieu", "schema.rb")
    end

    def env_file(dir)
      File.join(dir, ".env")
    end
  end
end
