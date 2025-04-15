# frozen_string_literal: true

module Milieu
  class Schema
    attr_reader :env_variables

    def self.define(&block)
      new.tap do |schema|
        schema.instance_eval(&block)
      end
    end

    def initialize
      @env_variables = {}
    end

    def add_env_variable(key, value)
      @env_variables[key] = value
      self
    end

    def write_to_file(dir)
      file_content = <<~TEXT
        Milieu::Schema.define do
          #{generate_schema_env_variable_line_definitions}
        end
      TEXT
      File.write("#{dir}/.milieu/schema.rb", file_content)
    end

    private

    def generate_schema_env_variable_line_definitions
      @env_variables
        .map { |env_key, env_value| "add_env_variable(\"#{env_key}\", \"#{env_value}\")\n" }
        .join
        .strip
    end
  end
end
