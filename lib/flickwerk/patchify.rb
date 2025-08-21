# frozen_string_literal: true

require "fileutils"
require "active_support"
require "active_support/core_ext/string"

module Flickwerk
  class Patchify
    def self.call(decorator_dir:, patches_dir:)
      directory_name = decorator_dir.split("/").last
      suffix = directory_name.singularize
      constant = suffix.camelize

      Dir.glob("#{decorator_dir}/**/*_#{suffix}.rb").each do |file|
        relative_path = file.sub(/^#{decorator_dir}\//, "")
        target_file = relative_path.sub("_#{suffix}.rb", "_patch.rb")
        target_path = File.join(patches_dir, File.dirname(relative_path))

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
