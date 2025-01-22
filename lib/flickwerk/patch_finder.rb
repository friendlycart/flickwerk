# frozen_string_literal: true

module Flickwerk
  class PatchFinder
    DECORATED_CLASS_PATTERN = /(?:::)?(?<decorated_class>[A-Z][\w.:]+?)(?:\.singleton_class)?\.prepend[\s(]/

    attr_reader :path, :autoloader

    def initialize(path, autoloader: Rails.autoloaders.main)
      @autoloader = autoloader
      @path = path
    end

    def call
      path.glob("**/*_patch.rb") do |patch_path|
        # Match all the classes that are prepended in the file
        matches = File.read(patch_path).scan(DECORATED_CLASS_PATTERN).flatten

        # Don't do a thing if there's no prepending.
        raise Flickwerk::Error, "No classes prepended in #{patch_path}" if matches.empty?

        # For each unique match, make sure we load the decorator when the base class is loaded
        matches.uniq.each do |decorated_class|
          # Zeitwerk tells us which constant it expects a file to provide.
          decorator_constant = autoloader.cpath_expected_at(patch_path)
          Flickwerk.patch(decorated_class, with: decorator_constant)
        end
      end
    end
  end
end
