# frozen_string_literal: true

require "flickwerk/patch_finder"
require "flickwerk/patch_loader"
require "rails/railtie"

class Flickwerk::Railtie < Rails::Railtie
  initializer "flickwerk.add_paths", before: :set_autoload_paths do |app|
    Flickwerk.patch_paths.each do |path|
      app.config.autoload_paths << path
    end
  end

  initializer "flickwerk.find_patches" do |app|
    app.reloader.to_prepare do
      Flickwerk.patch_paths.each do |path|
        Flickwerk::PatchFinder.new(path).call
      end
    end
  end

  initializer "flickwerk.add_patches", after: "flickwerk.find_patches" do |app|
    app.reloader.to_prepare do
      Flickwerk::PatchLoader.call
    end
  end
end
