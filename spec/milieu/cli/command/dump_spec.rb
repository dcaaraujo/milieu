# frozen_string_literal: true

require "tmpdir"

RSpec.describe Milieu::CLI::Command::Dump do
  around do |example|
    Dir.mktmpdir do |tmp|
      Dir.chdir(tmp) do
        example.run
      end
    end
  end

  describe "#call" do
    context "schema does not exist" do
      it "prints error" do
        expect { subject.call }.to output("Could not find schema.rb in your Milieu workspace.\n").to_stderr
      end
    end

    context "schema exists" do
      before { Milieu::CLI::Command::Init.new.call }

      it "calls exporter" do
        expect_any_instance_of(Milieu::EnvFileExporter).to receive(:export)
        subject.call
      end
    end
  end
end
