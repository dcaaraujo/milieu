# frozen_string_literal: true

module Milieu
  class EnvExporter
    def initialize(schema)
      @schema = schema
    end

    def export
      lines = env_variables
      lines << "" unless lines.empty?
      lines
    end

    private

    def env_variables
      @schema.map { |k, v| "#{k}=#{v}" }
    end
  end
end
