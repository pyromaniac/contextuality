# Contextuality

Contextuality allows you to make global variables for individual contexts.
It is threadsafe and can forward contexts inside `Thread.new {}` blocks.
Context is just variables name-value hash.
You can access any context variable inside context.

It is better than global variables or singleton because variables could be set
only higher in call stack and you know it. No more unexpected values.

## Installation

Add this line to your application's Gemfile:

    gem 'contextuality'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install contextuality

## Usage

### Simple usage

```
class Foo
  include Contextuality

  def self.foo
    contextuality.foo
  end

  def foo
    contextuality.foo
  end
end

contextualize(foo: 'Hello') do
  Foo.foo #=> "Hello"
end #=> "Hello"

contextualize(foo: 'Goodbye') do
  Foo.new.foo #=> "Goodbye"
end #=> "Goodbye"

# If context variable is not set - it returns nil
contextualize(bar: 'Hello') do
  Foo.new.foo #=> nil
end #=> nil

# Contexts can be stacked along the callstack
contextualize(foo: 'Hello') do
  contextualize(bar: 'Goodbye') do
    "#{Foo.new.foo} #{Foo.contextuality.bar}" #=> "Hello Goodbye"
  end #=> "Hello Goodbye"
end #=> "Hello Goodbye"

# Also context variables can be redefined deeper
contextualize(foo: 'Hello') do
  contextualize(foo: 'Goodbye') do
    Foo.new.foo #=> "Goodbye"
  end #=> "Goodbye"
  Foo.new.foo #=> "Hello"
end #=> "Hello"
```

You can include `Contextuality` in Object and get access to context everywhere,
or just include in classes on-demand.

### More complex example

```
class Article < ActiveRecord::Base
  include Contextuality

  def self.for_current_host
    if contextuality.host
      where(host: contextuality.host)
    else
      for_default_host # or just .all
    end
  end
end

class ArticlesController < ActionController::Base
  around_filter :setup_host

  def index
    @articles = Article.for_current_host
  end

private

  def setup_host
    contextualize(host: host_for(request.host)) do
      yield
    end
  end
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
