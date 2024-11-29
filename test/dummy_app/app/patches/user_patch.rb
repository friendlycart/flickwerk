module UserPatch
  def self.prepended(base)
    base.include(UserMethods)
  end

  def age
    26
  end

  User.prepend(self)
end
