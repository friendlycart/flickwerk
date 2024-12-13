# frozen_string_literal: true

require "active_support/core_ext/string"

module Flickwerk
  class Patchify
    PATCHES_DIR = "app/patches"
    def self.call(directory_name)
      directory_name ||= "decorators"
      source_dir = "app/#{directory_name}"
      suffix = directory_name.singularize
      constant = suffix.camelize

      Dir.glob("#{source_dir}/**/*_#{suffix}.rb").each do |file|
        relative_path = file.sub(/^#{source_dir}\//, "")
        target_file = relative_path.sub("_#{suffix}.rb", "_patch.rb")
        target_path = File.join(PATCHES_DIR, File.dirname(relative_path))

        # Create target directory if it doesn't exist
        FileUtils.mkdir_p(target_path)

        # Read and modify file content
        content = File.read(file)
        modified_content = content.gsub(/(\w+::)*\w+#{constant}\b/) do |match|
          match.sub(constant, "Patch")
        end

        # Write to the new file
        File.write(File.join(target_path, File.basename(target_file)), modified_content)

        # Delete the original file
        File.delete(file)

        puts "Moved and updated: #{file} -> #{File.join(target_path, File.basename(target_file))}"
      end
    end
  end
end
