# frozen_string_literal: true

RSpec.describe Milieu::CLI::Command::Version do
  describe "#call" do
    it "prints version number to stdout" do
      expect { subject.call }.to output("#{Milieu::VERSION}\n").to_stdout
    end
  end
end
