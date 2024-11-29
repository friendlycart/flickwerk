# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
$LOAD_PATH.unshift File.expand_path("dummy_cms/lib", __dir__)
$LOAD_PATH.unshift File.expand_path("dummy_blog/lib", __dir__)

require "flickwerk"

require "minitest/autorun"
