# frozen_string_literal: true

module Milieu
  class Schema
    attr_accessor :env_variables

    def self.create(&block)
      new.tap do |schema|
        schema.instance_eval(&block)
      end
    end

    def initialize
      @env_variables = {}
    end

    def add(key, value)
      @env_variables[normalize_key(key)] = value
      self
    end

    def remove(key)
      @env_variables.delete(normalize_key(key))
      self
    end

    private

    def normalize_key(key)
      key.to_s.upcase
    end
  end
end
