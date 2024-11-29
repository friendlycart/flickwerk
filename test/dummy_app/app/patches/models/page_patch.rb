module PagePatch
  def title
    "Changed from Host app"
  end

  DummyCms::Page.prepend(self)
end
