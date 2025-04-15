# frozen_string_literal: true

require "test_helper"
require "fileutils"

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
      Dir.mktmpdir do |tmp_dir|
        @subject.start(["init", tmp_dir, "--quiet"])
        assert Dir.exist?(File.join(tmp_dir, ".milieu"))
      end
    end

    def test_init_creates_a_schema_file
      Dir.mktmpdir do |tmp_dir|
        @subject.start(["init", tmp_dir, "--quiet"])
        assert File.exist?(File.join(tmp_dir, ".milieu", "schema.rb"))
      end
    end

    def test_setup_creates_env_file
      Dir.mktmpdir do |tmp_dir|
        create_milieu_folder(tmp_dir)
        Milieu::Schema.new.write_to_file(tmp_dir)

        @subject.start(["setup", tmp_dir, "--quiet"])

        env_file = File.join(tmp_dir, ".env")
        assert File.exist?(env_file)
        assert File.zero?(env_file)
      end
    end

    def test_setup_writes_env_schema_to_env_file
      Dir.mktmpdir do |tmp_dir|
        create_milieu_folder(tmp_dir)
        schema = Milieu::Schema.new
        schema.add_env_variable("MY_ENV_VARIABLE", "My ENV variable has a value")
        schema.add_env_variable("MY_SECOND_ENV_VARIABLE", "My second ENV variable has a value")
        schema.write_to_file(tmp_dir)

        @subject.start(["setup", tmp_dir, "--quiet"])

        env_file = File.join(tmp_dir, ".env")
        assert File.exist?(env_file)

        env_file_content = File.readlines(env_file)
        assert_equal 2, env_file_content.length
        assert_equal "MY_ENV_VARIABLE=\"My ENV variable has a value\"", env_file_content[0].strip
        assert_equal "MY_SECOND_ENV_VARIABLE=\"My second ENV variable has a value\"", env_file_content[1].strip
      end
    end
  end
end
