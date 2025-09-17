# frozen_string_literal: true

require "dry/cli"

module Milieu
  module CLI
    module Command
      class Init < Dry::CLI::Command
        desc "Create a new Milieu workspace"

        argument :path

        def call(path: ".", **)
          @milieu_folder = File.join(path, ".milieu")
          if Dir.exist?(@milieu_folder)
            warn "Milieu workspace already exists.\n"
            return
          end
          create_workspace_dir
          create_schema_file
        end

        private

        def create_workspace_dir
          Dir.mkdir(@milieu_folder)
        end

        def create_schema_file
          schema_file_path = File.join(@milieu_folder, "schema.rb")
          content = <<~RUBY
            # frozen_string_literal: true
            
            Milieu::Schema.create do
            end
          RUBY
          File.write(schema_file_path, content)
        end
      end
    end
  end
end
