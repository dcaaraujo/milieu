# frozen_string_literal: true

require "dry/cli"

module Milieu
  module CLI
    module Registry
      extend Dry::CLI::Registry

      register "version", Command::Version, aliases: ["-v", "--version"]
      register "init", Command::Init
      register "dump", Command::Dump
    end
  end
end
