# frozen_string_literal: true

require_relative "flickwerk/version"
require "active_support/core_ext/module/attribute_accessors"
require "flickwerk/railtie" if defined?(Rails)

module Flickwerk
  class Error < StandardError; end

  mattr_accessor :patch_paths, default: []
  mattr_accessor :patches, default: Hash.new([])
  mattr_accessor :aliases, default: {}

  def self.included(engine)
    engine.root.glob("app/patches/*").each do |path|
      engine.patch_paths << path
    end
  end

  def self.patch(class_name, with:)
    klass_name = aliases[class_name] || class_name
    patches[klass_name] += [with]
  end
end
