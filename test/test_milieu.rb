# frozen_string_literal: true

require "test_helper"

class TestMilieu < Minitest::Test
  def test_version_number
    refute_nil Milieu::VERSION
  end
end
