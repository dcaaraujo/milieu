# frozen_string_literal: true

require "milieu"
require "thor"

module Milieu
  class CLI < Thor
    include Thor::Actions

    def self.exit_on_failure?
      true
    end

    def self.source_root
      File.dirname(__FILE__)
    end

    desc "version", "Prints current version"
    def version
      puts Milieu::VERSION
    end

    desc "init DIR", "Creates a new Milieu workspace"
    option :quiet, type: :boolean, required: false
    def init(dir)
      empty_directory(File.join(dir, ".milieu"), verbose: !options[:quiet])
      new_schema = Milieu::Schema.new(version: 0)
      output = Milieu::SchemaExporter.new(new_schema).export.join("\n")
      create_file(schema_file_path(dir), output, verbose: !options[:quiet])
    end

    desc "setup DIR", "Export schema to env file"
    option :quiet, type: :boolean, required: false
    def setup(dir)
      schema = instance_eval(File.read(schema_file_path(dir)))
      output = Milieu::EnvExporter.new(schema).export.join("\n")
      create_file(File.join(dir, ".env"), output, verbose: !options[:quiet])
    end

    private

    def schema_file_path(dir)
      File.join(dir, ".milieu", "schema.rb")
    end
  end
end
