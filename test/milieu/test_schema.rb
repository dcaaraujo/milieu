# frozen_string_literal: true

require "test_helper"

module Milieu
  class TestSchema < MilieuTest
    def test_new_instance_has_no_env_variables
      subject = Milieu::Schema.new
      assert_empty subject.env_variables
    end

    def test_add_env_variable
      subject = Milieu::Schema.new
      subject.add_env_variable("MY_ENV_VARIABLE", "This is my ENV variable")
      refute_empty subject.env_variables
      assert subject.env_variables.key?("MY_ENV_VARIABLE")
    end

    def test_write_to_file_creates_empty_schema_file
      Dir.mktmpdir do |tmp_dir|
        create_milieu_folder(tmp_dir)

        schema = Milieu::Schema.new
        schema.write_to_file(tmp_dir)

        schema_file = File.readlines(File.join(tmp_dir, ".milieu", "schema.rb"))
        assert_equal "Milieu::Schema.define do", schema_file.first.strip
        assert_equal "end", schema_file.last.strip
      end
    end

    def test_write_to_file_create_schema_file_declaring_env_variables
      Dir.mktmpdir do |tmp_dir|
        create_milieu_folder(tmp_dir)

        schema = Milieu::Schema.new
        schema.add_env_variable("MY_ENV_VARIABLE", "This is my ENV variable")
        schema.write_to_file(tmp_dir)

        schema_file = File.readlines(File.join(tmp_dir, ".milieu", "schema.rb"))
        assert_match("Milieu::Schema.define do", schema_file.first.strip)
        assert_equal("add_env_variable(\"MY_ENV_VARIABLE\", \"This is my ENV variable\")", schema_file[1].strip)
        assert_match("end", schema_file.last.strip)
      end
    end
  end
end
