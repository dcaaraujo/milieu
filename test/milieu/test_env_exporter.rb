# frozen_string_literal: true

require "test_helper"
require "milieu/env_exporter"

module Milieu
  class TestEnvExporter < MilieuTest
    def test_export_exports_nothing
      schema = Milieu::Schema.new(version: 1)
      subject = Milieu::EnvExporter.new(schema)
      assert_empty subject.export
    end

    def test_export_returns_env_variables
      schema = Milieu::Schema.create(version: 1) do
        define_env_variable("EXAMPLE1", "An example env variable")
        define_env_variable("EXAMPLE2", "A second example env variable")
        define_env_variable("EXAMPLE3", 3)
      end
      expected_output = [
        %(EXAMPLE1="An example env variable"),
        %(EXAMPLE2="A second example env variable"),
        %(EXAMPLE3=3),
        ""
      ]

      subject = Milieu::EnvExporter.new(schema)
      assert_equal expected_output, subject.export
    end
  end
end
