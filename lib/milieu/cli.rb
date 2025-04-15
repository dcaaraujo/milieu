# frozen_string_literal: true

require "thor"

module Milieu
  class CLI < Thor
    include Thor::Actions

    desc "version", "Prints current version"
    def version
      puts Milieu::VERSION
    end

    desc "init DIR", "Creates a new Milieu workspace"
    option :quiet, type: :boolean, required: false
    def init(dir)
      empty_directory("#{dir}/.milieu", verbose: !options[:quiet])
      create_file("#{dir}/.milieu/.keep", verbose: !options[:quiet])
      Milieu::Schema.new.write_to_file(dir)
    end

    desc "setup DIR", "Create your env files based on the current schema. It will overwrite your existing files!"
    option :quiet, type: :boolean, required: false
    def setup(dir)
      schema = load_schema_file(dir)
      file_content = schema.env_variables
        .map { |env_key, env_value| "#{env_key}=\"#{env_value}\"" }
        .join("\n")

      create_file("#{dir}/.env", verbose: !options[:quiet])
      File.write("#{dir}/.env", file_content)
    end

    private

    def load_schema_file(dir)
      schema_file_content = File.read("#{dir}/.milieu/schema.rb")
      instance_eval(schema_file_content)
    end
  end
end
