module UserClassMethodsPatch
  def address
    "The outer rim"
  end

  DummyApp.user_class.singleton_class.prepend(self)
end
