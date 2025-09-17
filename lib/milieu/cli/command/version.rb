# frozen_string_literal: true

require "dry/cli"

module Milieu
  module CLI
    module Command
      class Version < Dry::CLI::Command
        desc "Prints the current version"

        def call(*)
          puts Milieu::VERSION
        end
      end
    end
  end
end
