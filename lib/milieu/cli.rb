# frozen_string_literal: true

require "dry/cli"

module Milieu
  module CLI
    extend self

    def run
      Dry::CLI.new(Milieu::CLI::Registry).call
    end
  end
end
