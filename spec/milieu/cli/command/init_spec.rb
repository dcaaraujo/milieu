# frozen_string_literal: true

require "tmpdir"

RSpec.describe Milieu::CLI::Command::Init do
  around do |example|
    Dir.mktmpdir do |tmp|
      Dir.chdir(tmp) do
        example.run
      end
    end
  end

  describe "#call" do
    context "workspace does not exist" do
      context "milieu is run in current folder" do
        it "creates a workspace folder" do
          subject.call
          expect(Dir.exist?(".milieu")).to be true
        end

        it "creates a schema.rb file" do
          subject.call
          expect(File.exist?(File.join(".milieu", "schema.rb"))).to be true
        end

        it "schema file contains schema definition" do
          subject.call
          schema = File.read(File.join(".milieu", "schema.rb"))
          expect(schema).to eq "# frozen_string_literal: true\n\nMilieu::Schema.create do\nend\n"
        end
      end

      context "milieu is provided a path" do
        let!(:app_path) { "my_app" }
        let!(:expected_path) { File.join(app_path, ".milieu") }

        before do
          Dir.mkdir(app_path)
        end

        it "creates a workspace folder" do
          subject.call(path: app_path)
          expect(Dir.exist?(expected_path)).to be true
        end
      end
    end

    context "workspace already exists" do
      before do
        subject.call
      end

      it "prints error" do
        expect { subject.call }.to output("Milieu workspace already exists.\n").to_stderr
      end
    end
  end
end
