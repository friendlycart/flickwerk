# frozen_string_literal: true

module Flickwerk
  class PatchLoader
    def self.call(autoloader: Rails.autoloaders.main)
      Flickwerk.patches.each do |class_name, decorators|
        autoloader.on_load(class_name) do
          if Flickwerk.verbose
            Flickwerk.log(
              "Loading patches for #{class_name}: #{decorators.map(&:to_s).join(", ")}"
            )
          end
          decorators.each(&:constantize)
        end
      end
    end
  end
end
