# frozen_string_literal: true

require_relative "lib/flickwerk/version"

Gem::Specification.new do |spec|
  spec.name = "flickwerk"
  spec.version = Flickwerk::VERSION
  spec.authors = ["Martin Meyerhoff"]
  spec.email = ["mamhoff@gmail.com"]

  spec.summary = "Support for lazy loading patches in Rails engines"
  spec.description = "Support for lazy loading patches in Rails engines"
  spec.homepage = "https://github.com/friendlycart/flickwerk"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/friendlycart/flickwerk"
  spec.metadata["changelog_uri"] = "https://github.com/friendlycart/flickwerk/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "railties", ">= 7.0"
end
