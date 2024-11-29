module DummyBlogPostPatch
  def title
    "Edited from CMS"
  end

  DummyBlog::Post.prepend(self)
end
