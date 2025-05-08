# frozen_string_literal: true

module Milieu
  class Schema
    attr_reader :env_variables, :version

    def initialize(version:)
      @version = version
      @env_variables = {}
    end

    def self.create(version:, &block)
      new(version:).tap do |schema|
        schema.instance_eval(&block)
      end
    end

    def define_env_variable(key, value)
      @env_variables[key] = value
      self
    end

    def include?(key)
      @env_variables.include?(key)
    end

    def map
      @env_variables.sort.map do |key, raw_value|
        value = case raw_value
        when String
          %("#{raw_value}")
        else
          raw_value
        end
        yield key, value
      end
    end
  end
end
