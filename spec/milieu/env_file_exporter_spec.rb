# frozen_string_literal: true

require "tmpdir"

RSpec.describe Milieu::EnvFileExporter do
  around do |example|
    Dir.mktmpdir do |tmp|
      Dir.chdir(tmp) do
        example.run
      end
    end
  end

  let(:schema) do
    schema = Milieu::Schema.new
    schema.add("MY_ENV_VARIABLE_1", "This is my first environment variable")
    schema.add("MY_ENV_VARIABLE_2", "This is my second environment variable")
    schema.add("MY_INT_ENV_VARIABLE", 100)
  end

  subject { Milieu::EnvFileExporter.new(schema) }

  before { Milieu::CLI::Command::Init.new.call }

  describe "#export" do
    before { subject.export }

    it "creates .env file" do
      expect(File.exist?(".env")).to be true
    end

    it "defines env variables to .env file" do
      content = File.readlines("./.env")
      expect(content[0]).to eq("MY_ENV_VARIABLE_1=\"This is my first environment variable\"\n")
      expect(content[1]).to eq("MY_ENV_VARIABLE_2=\"This is my second environment variable\"\n")
      expect(content[2]).to eq("MY_INT_ENV_VARIABLE=100\n")
    end
  end
end
