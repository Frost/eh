# Eh

![Build status](http://img.shields.io/travis/Frost/eh.svg)

Look up Elixir documentation from the command line

`eh` basically works like `IEx.Helpers.h`, except that you can run it
from the command line.

It prints the documentation for its first argument, if it can find any
documentation on it.

## Eh for your code

Eh comes with a mix task for looking up code, `mix eh`. It can find
documentation on any code it is compiled with, so if you install it
standalone, it will only be able to lookup built-in Elixir documentation
and its own documentation.

What's more interesting is to use it to lookup documentation on your
own packages, or on dependencies in your application. By adding `eh` as
a development dependency to your package, you can do that from outside
of `iex`, e.g. from your editor.

### Setting up `eh` for your project

Add `eh` as a development dependency to your project:

```elixir
# mix.exs

def dependencies do
  [{:eh, only: :dev}]
end
```

Install dependencies

    mix deps.get
    mix deps.compile

You should now be able to use `mix eh` to lookup code in your project!

### Global installation

You can also install eh for your 

You can install `eh` with git, like so

### Install with git

    git clone git@github.com:Frost/eh.git
    cd eh
    mix escript.build
    ./eh Eh

Then you can put the `eh` binary somewhere in your `$PATH` and use it
from anywhere, like `set :keywordprog=/path/to/eh` in your vimrc and
for Elixir files, and be able to lookup Elixir documentation with `K`.

## Usage

Examples:

* `mix eh String`              - Module docs for `String`
* `mix eh is_binary`           - Docs for `Kernel.is_binary`
* `mix eh String.to_integer`   - Docs for any arity of `String.to_integer`
* `mix eh String.to_integer/1` - Docs for `String.to_integer/1`
* `mix eh String.to_integer/2` - Docs for `String.to_integer/2`

## Why monochrome?

The output from `eh` is monochrome because some colors don't really work
very well in some terminals. For instance, having bright yellow as a
documentation header on a white background (or the reverse of that)
makes the text completely illegible. That specific example was fixed in
[my pull request](https://github.com/elixir-lang/elixir/pull/2882), but
there might be other color combinations out there that also get messed
up, so therefore I chose to output the documentation in monochrome.

## About

The project is inspired by ri (ruby interactive), that basically does
the same thing, but for ruby.

I also took a lot of inspiration from `IEx.Helpers.h`, since I basically
wanted that, but without having to fire up IEx first.

## Mentions

Some of the code for extracting documentation from modules is more or
less borrowed straight out of `IEx.Introspection.h`, and thate code is
copyright 2012-2013 Plataformatec.

## Contributions

Pull requests are welcome.

## TODO

* `eh String.to_integer(some, args)` -> `String.to_integer/2`
