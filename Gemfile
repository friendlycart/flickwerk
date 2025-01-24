# frozen_string_literal: true

source "https://rubygems.org"

# Specify your gem's dependencies in flickwerk.gemspec
gemspec

gem "rake", "~> 13.0"

gem "minitest", "~> 5.16"

gem "standard", "~> 1.3"

rails_version = ENV.fetch("RAILS_VERSION", "8.0")

# concurrent-ruby v1.3.5 has removed the dependency on logger,
# affecting Rails 7.0.
# https://github.com/rails/rails/pull/54264
if rails_version == "7.0"
  gem "concurrent-ruby", "< 1.3.5"
end

gem "railties", "~> #{rails_version}.0"
