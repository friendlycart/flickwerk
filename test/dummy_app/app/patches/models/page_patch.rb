module PagePatch
  def self.prepended(base)
    base.prepend(InstanceMethods)
  end

  def title
    "Changed from Host app"
  end

  module InstanceMethods
    def name
      "Homepage"
    end
  end

  ::DummyCms::Page.prepend(self)
end
