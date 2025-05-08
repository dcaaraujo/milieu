# frozen_string_literal: true

module Milieu
  class SchemaExporter
    def initialize(schema)
      @schema = schema
    end

    def export
      schema_file_lines = []
      schema_file_lines << "# frozen_string_literal: true"
      schema_file_lines << ""
      schema_file_lines << "Milieu::Schema.create(version: #{@schema.version}) do"
      schema_file_lines.concat(env_variables)
      schema_file_lines << "end"
      schema_file_lines << ""
      schema_file_lines
    end

    private

    def env_variables
      @schema.map { |k, v| %{  define_env_variable("#{k}", #{v})} }
    end
  end
end
