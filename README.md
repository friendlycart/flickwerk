# Flickwerk

A Railtie for loading autoloadable patches using Zeitwerk. This speeds up Rails bootup and reload time considerably, because other solutions out there load the patches and the associated classes on application bootup, and this gem defers loading the patches until the patched classes are autoloaded.

## Installation

```bash
bundle add flickwerk
```

## Usage

Include Flickwerk in your `application.rb` or `engine.rb` file, depending on whether you want to add patches to external libraries from an engine or from your host app.

```rb
# config/application.rb
# ...
class MyApplication < Rails::Application
  include Flickwerk

  # ...
end
```

Then, add patches to `app/patches/models` or `app/patches/controllers` that can be autoloaded.

```rb
# app/patches/models/user_patch.rb
module UserPatch
  def name
    "Engelbert Humperdinck"
  end

  User.prepend self
end
```

Now, all your users will have Engelbert Humperdinck's name.

You can use Ruby's `prepended` hook in order to run class methods. That's useful for adding scopes or ActiveRecord relationships.

```rb
# app/patches/models/spree_order_patch.rb

module SpreeOrderPatch
  def self.prepended(base)
    base.has_many :goodies
  end

  Spree::Order.prepend self
end
```

If you application now has a class `Goodie` with a foreign key to the `spree_orders` table, you can check on those goodies using the familiar `order.goodies` in your application.


### Using Flickwerk in Engines

You can also include Flickwerk in your `engine.rb` file and add patches to your gem.

```rb
# lib/my_gem/engine.rb

class MyGem::Engine < Rails::Engine
  include Flickwerk
  # ...
end
```

It's advisable to namespace your patches so they do not conflict with patches added elsewhere:

```rb
# app/patches/modes/my_engine/spree_order_patch.rb
module MyEngine::SpreeOrderPatch
  def self.prepended(base)
    base.scope :with_goodies, -> { joins(:goodies).where.not(goodie_id: nil) }
  end

  Spree::Order.prepend self
end
```

### Using `super`

Sometimes you want to modify the original result of a method dynamically rather than just overwrite it. Because your patches use `Module.prepend`, this can be easily accomplished, even if you want to modify class methods:

```rb
# app/models/spree_order_patch.rb

module SpreeOrderPatch
  module ClassMethods
    def ransackable_associations
      super + ["goodies"]
    end
  end

  def self.prepended(base)
    base.extend ClassMethods
  end

  def total
    super - goodies.sum(&:amount)
  end

  Spree::Order.prepend self
end
```

### Manual patches

Flickwerk will look for the string `.prepend` in your patches in order to know which class should be patched. In some circumstances, the name of the class being patched is the result of a method call though, as in the case of patching Solidus' configurable user class. In these cases, you'll have to register the patch with Flickwerk manually:

```rb
# app/patches/models/my_gem/user_class_patch.rb

module MyGem::UserClassPatch
  def name
    "Dr. #{super}"
  end
end
```

```rb
# lib/my_gem/engine.rb

require "flickwerk"

class MyGem::Engine < Rails::Engine
  include Flickwerk

  initializer "my_gem.patch_user_class", before: "flickwerk.add_patches" do
    Flickwerk.patch(Spree.class_variable_get(:@@user_class), "MyGem::UserClassPatch")
  end
end
```


### Patching non-autoloadable classes

Classes that are not autoloaded (very generally, that's everything in the `lib` folder) cannot be loaded using the mechanism Flickwerk provides. Put any patches you have for these into your own `lib` folder and `require` them at your discretion:

```rb
# lib/my_gem/spree_patch.rb

module MyGem::SpreePatch
  module ClassMethods
    def river_name
      "Havel"
    end
  end

  def self.prepended(base)
    base.extend ClassMethods
  end

  Spree.prepend self
end
```

Require these in a config.to_prepare block in your application

```rb
# lib/my_gem/engine.rb

class MyGem::Engine
  # ...
  initializer "load_lib_patches" do
    config.to_prepare do
      root.join("lib/patches").glob("**/*.rb").each do |f|
        require f
      end
    end
  end
  # ...
end
```

## Transitioning from app/decorators to app/patches

Due to the Rails Engine documentation telling people to put their patches in either `app/decorators` or `app/overrides`, that's where a lot of patches currently live. Flickwerk provides a script to help you move your "decorators" or "overrides" to `app/patches` and do the necessary changes in terms of file and constant names.

If your patches currently live in `app/decorators`, run

```sh
bundle exec flickwerk patchify
```

Flickwerk will now move your decorators and rename them.

If your patches currently live in `app/overrides`, use an argument:

```sh
bundle exec flickwerk patchify app/overrides
```

If you have patches in `lib`, they can be moved to `lib/patches`:

```sh
bundle exec flickwerk patchify lib/decorators lib/patches
```

Now, run your tests and make sure your patches comply with Flickwerk's requirements.

## Considerations

### Aren't patches bad?

Patches are often not the ideal solution. It's often preferable to fix any bugs upstream, or to use a specialized object just in those contexts where necessary. However, in some ecosystems, like the Spree/Solidus ones, core classes are extended in extension gems, and especially things like adding associations can be impossible on anything than the correct ActiveRecord class.

Choose your patches carefully, and always look for better solutions than a patch. Sometimes, they're a good, pragmatic solution though.

### Why don't you call these monkey patches?

Because there are no monkeys involved in writing them - to my knowledge, this is all the work of human beings.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/friendlycart/flickwerk. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/flickwerk/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Flickwerk project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/flickwerk/blob/main/CODE_OF_CONDUCT.md).
