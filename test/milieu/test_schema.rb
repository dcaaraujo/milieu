# frozen_string_literal: true

require "test_helper"
require "milieu/schema"

module Milieu
  class TestSchema < MilieuTest
    def test_empty_schema
      subject = Milieu::Schema.new(version: 0)
      assert_empty subject.env_variables
    end

    def test_adding_env_variable_to_schema
      subject = Milieu::Schema.new(version: 0)
      subject.define_env_variable("EXAMPLE", "An example env variable")
      refute_empty subject.env_variables
      refute_nil subject.env_variables["EXAMPLE"]
    end

    def test_adding_env_variable_returns_self
      subject = Milieu::Schema.new(version: 0)
      result = subject.define_env_variable("EXAMPLE", "An example env variable")
      assert_same subject, result
    end

    def test_version
      subject = Milieu::Schema.new(version: 0)
      assert_equal 0, subject.version
    end

    def test_include
      subject = Milieu::Schema.new(version: 0)
      subject.define_env_variable("EXAMPLE", "An example env variable")
      assert subject.include?("EXAMPLE")
      refute subject.include?("DOES_NOT_EXIST")
    end

    def test_create_creates_new_instance
      version = 2025_04_27_184502
      subject = Milieu::Schema.create(version: version) do
        define_env_variable("EXAMPLE", "An example env variable")
      end
      assert_equal version, subject.version
      refute_nil subject.env_variables["EXAMPLE"]
    end

    def test_map_returns_empty_array
      subject = Milieu::Schema.new(version: 0)
      result = subject.map { |k, v| v }
      assert_instance_of Array, result
      assert_empty result
    end

    def test_map
      subject = Milieu::Schema.create(version: 0) do
        define_env_variable("EXAMPLE1", "An example env variable")
        define_env_variable("EXAMPLE2", "Another example env variable")
        define_env_variable("EXAMPLE3", 3)
        define_env_variable("EXAMPLE4", 3.14)
      end
      expected_result = [
        %(EXAMPLE1 -> "An example env variable"),
        %(EXAMPLE2 -> "Another example env variable"),
        "EXAMPLE3 -> 3",
        "EXAMPLE4 -> 3.14"
      ]
      result = subject.map { |k, v| "#{k} -> #{v}" }
      assert_equal expected_result, result
    end
  end
end
