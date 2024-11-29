# frozen_string_literal: true

require_relative "flickwerk/version"
require "active_support/core_ext/module/attribute_accessors"
require "flickwerk/railtie" if defined?(Rails)

module Flickwerk
  class Error < StandardError; end

  mattr_accessor :patch_paths
  self.patch_paths = []

  def self.included(engine)
    patch_paths << engine.root.join("app/patches")
  end
end
