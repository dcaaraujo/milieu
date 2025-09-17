# frozen_string_literal: true

require "dry/cli"

module Milieu
  module CLI
    module Command
      class Dump < Dry::CLI::Command
        desc "Creates or replaces .env file from schema"

        argument :path

        def call(path: ".", **)
          @schema_file = File.join(path, ".milieu", "schema.rb")
          unless File.exist?(@schema_file)
            warn "Could not find schema.rb in your Milieu workspace.\n"
            return
          end
          export_env_file
        end

        private

        def export_env_file
          Milieu::EnvFileExporter.new(read_schema).export
        end

        def read_schema
          instance_eval(File.read(@schema_file))
        end
      end
    end
  end
end
