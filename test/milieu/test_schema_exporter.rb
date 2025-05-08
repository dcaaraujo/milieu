# frozen_string_literal: true

require "test_helper"
require "milieu/schema_exporter"

module Milieu
  class TestSchemaExporter < MilieuTest
    def test_export_exports_empty_schema
      schema = Milieu::Schema.new(version: 1)
      expected_lines = [
        "# frozen_string_literal: true",
        "",
        "Milieu::Schema.create(version: 1) do",
        "end",
        ""
      ]

      subject = Milieu::SchemaExporter.new(schema)
      assert_equal expected_lines, subject.export
    end

    def test_export_exports_env_variables_using_dsl
      schema = Milieu::Schema.create(version: 1) do
        define_env_variable("EXAMPLE1", "An example env variable")
        define_env_variable("EXAMPLE2", "A second example env variable")
        define_env_variable("EXAMPLE3", 3)
      end
      expected_lines = [
        "# frozen_string_literal: true",
        "",
        "Milieu::Schema.create(version: 1) do",
        %{  define_env_variable("EXAMPLE1", "An example env variable")},
        %{  define_env_variable("EXAMPLE2", "A second example env variable")},
        %{  define_env_variable("EXAMPLE3", 3)},
        "end",
        ""
      ]

      subject = Milieu::SchemaExporter.new(schema)
      assert_equal expected_lines, subject.export
    end
  end
end
