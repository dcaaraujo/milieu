# frozen_string_literal: true

require_relative "lib/milieu/version"

Gem::Specification.new do |spec|
  spec.name = "milieu"
  spec.version = Milieu::VERSION
  spec.authors = ["Christopher Araujo"]
  spec.summary = "A simple tool to gracefully manage your env files."
  spec.homepage = "https://github.com/dcaaraujo/milieu"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2.0"
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/dcaaraujo/milieu"
  spec.metadata["changelog_uri"] = "https://github.com/dcaaraujo/milieu/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/setup bin/console Gemfile .gitignore .rspec spec/ .standard.yml])
    end
  end
  spec.bindir = "bin"
  spec.executables = ["milieu"]
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "dry-cli", "~> 1.3"
  spec.add_runtime_dependency "zeitwerk", "~> 2.7"

  spec.add_development_dependency "irb"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "standard", "~> 1.3"

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
