# frozen_string_literal: true

require "flickwerk/patch_loader"

class Flickwerk::Railtie < Rails::Railtie
  initializer "flickwerk.add_patches", after: :setup_main_autoloader do
    Flickwerk.patch_paths.each do |path|
      Flickwerk::PatchLoader.new(path).call
    end
  end
end
