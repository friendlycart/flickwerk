module UserPatch
  def self.prepended(base)
    base.include(UserMethods)
  end

  def age
    26
  end

  DummyApp.user_class.prepend(self)
end
