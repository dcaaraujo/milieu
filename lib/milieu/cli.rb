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
    end
  end
end
