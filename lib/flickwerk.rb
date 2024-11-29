# frozen_string_literal: true

require_relative "flickwerk/version"
require "active_support/core_ext/module/attribute_accessors"
require "flickwerk/railtie" if defined?(Rails)

module Flickwerk
  class Error < StandardError; end

  mattr_accessor :patch_paths
  self.patch_paths = []

  def self.included(engine)
    engine.root.glob("app/patches/*").each do |path|
      engine.patch_paths << path
    end
  end
end
