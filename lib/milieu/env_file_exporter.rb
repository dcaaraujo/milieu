# frozen_string_literal: true

module Milieu
  class EnvFileExporter
    def initialize(schema)
      @schema = schema
    end

    def export
      File.write("./.env", export_schema)
    end

    def export_schema
      @schema.env_variables.map { |key, value| "#{key}=#{format_value(value)}\n" }.join
    end

    def format_value(value)
      case value
      when String
        %("#{value}")
      else
        value
      end
    end
  end
end
