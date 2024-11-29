# frozen_string_literal: true

require "test_helper"
require "active_support/test_case"
require "active_support/testing/isolation"

class ZeitwerkIntegrationTest < ActiveSupport::TestCase
  include ActiveSupport::Testing::Isolation

  def setup
    require_relative "dummy_app/config/application"
  end

  def boot
    DummyApp::Application.initialize!
  end

  test "autoloading patches" do
    boot

    assert User
    assert User.new.respond_to?(:name)
    assert User.new.respond_to?(:age)
    assert_equal 26, User.new.age
    assert_equal "Vader", User.new.last_name
    assert_equal "Darth", User.new.name
  end

  test "autoloading patches for an engine" do
    require "dummy_cms"

    boot

    assert DummyCms::Page
    assert DummyCms::Page.new.respond_to?(:title)
    assert_equal "Changed from Host app", DummyCms::Page.new.title
  end

  test "autoloading the unpatched blog engine" do
    require "dummy_blog"

    boot

    assert DummyBlog::Post
    assert DummyBlog::Post.new.respond_to?(:title)
    assert_equal "Original title", DummyBlog::Post.new.title
  end

  test "autoloading patches from an engine" do
    require "dummy_blog"
    require "dummy_cms"

    boot

    assert DummyBlog::Post
    assert DummyBlog::Post.new.respond_to?(:title)
    assert_equal "Edited from CMS", DummyBlog::Post.new.title
  end
end
