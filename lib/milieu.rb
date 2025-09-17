# frozen_string_literal: true

require "zeitwerk"

loader = Zeitwerk::Loader.for_gem
loader.setup
loader.inflector.inflect("cli" => "CLI")

module Milieu
end
