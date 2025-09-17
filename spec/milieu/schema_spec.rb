# frozen_string_literal: true

RSpec.describe Milieu::Schema do
  describe "#new" do
    it "creates an empty dictionary" do
      expect(subject.env_variables).to be_empty
    end
  end

  describe "#add" do
    it "returns self" do
      result = subject.add("MY_ENV_VARIABLE", "This is my environment variable")
      expect(result).to be subject
    end

    it "adds env variable to schema" do
      subject.add("MY_ENV_VARIABLE", "This is my environment variable")
      expect(subject.env_variables).to include("MY_ENV_VARIABLE" => "This is my environment variable")
    end

    it "converts key to uppercase string when providing symbol" do
      subject.add(:my_env_variable, "This is my environment variable")
      expect(subject.env_variables).to include("MY_ENV_VARIABLE" => "This is my environment variable")
    end
  end

  describe "#remove" do
    before do
      subject.add("MY_ENV_VARIABLE_1", "This is my environment variable")
      subject.add("MY_ENV_VARIABLE_2", "This is my environment variable")
    end

    it "returns self" do
      result = subject.remove("MY_ENV_VARIABLE_1")
      expect(result).to be subject
    end

    it "deletes env variable" do
      subject.remove("MY_ENV_VARIABLE_1")
      expect(subject.env_variables).to_not include("MY_ENV_VARIABLE_1" => "This is my environment variable")
    end
  end

  describe "#create" do
    subject { Milieu::Schema }

    it "runs provided block" do
      schema = subject.create do
        add("MY_ENV_VARIABLE_1", "This is my first environment variable")
        add("MY_ENV_VARIABLE_2", "This is my second environment variable")
      end
      expect(schema.env_variables).to include(
        "MY_ENV_VARIABLE_1" => "This is my first environment variable",
        "MY_ENV_VARIABLE_2" => "This is my second environment variable"
      )
    end
  end
end
