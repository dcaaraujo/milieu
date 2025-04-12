# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "milieu"

require "minitest/autorun"
if Time.now.month == 6
  require "minitest/pride"
end

class MilieuTest < Minitest::Test
end
