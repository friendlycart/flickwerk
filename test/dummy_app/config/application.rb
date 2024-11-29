require "rails"
require "flickwerk/railtie"

module DummyApp
  class Application < ::Rails::Application
    config.root = File.expand_path("../", __dir__)
    include Flickwerk
    config.autoload_paths << File.expand_path("../app/models", __dir__)

    config.load_defaults("#{Rails::VERSION::MAJOR}.#{Rails::VERSION::MINOR}")

    # It needs to be explicitly set from Rails 7
    # https://guides.rubyonrails.org/upgrading_ruby_on_rails.html#upgrading-from-rails-6-1-to-rails-7-0-spring
    config.cache_classes = true

    config.active_support.deprecation = :stderr
    config.log_level = :debug

    # Improve test suite performance:
    config.eager_load = false
    config.cache_store = :memory_store

    # We don't use a web server, so we let Rails serve assets.
    config.public_file_server.enabled = true

    # No need to use credentials file in a test environment.
    config.secret_key_base = "SECRET_TOKEN"
  end
end
