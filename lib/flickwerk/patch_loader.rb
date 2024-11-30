# frozen_string_literal: true

module Flickwerk
  class PatchLoader
    def self.call(autoloader: Rails.autoloaders.main)
      Flickwerk.patches.each do |class_name, decorators|
        autoloader.on_load(class_name) do
          decorators.each(&:constantize)
        end
      end
    end
  end
end
