# Eh

Look up Elixir documentation from the command line

## Usage

`eh` basically works like `IEx.Helpers.h`, except that you can run it
from the command line.

It prints the documentation for its first argument, if it can find any
documentation on it.

Examples:

* `eh is_binary`           - Module docs for `Kernel.is_binary`
* `eh String`              - Module docs for `String`
* `eh String.to_integer`   - Docs for any arity of `String.to_integer`
* `eh String.to_integer/1` - Docs for `String.to_integer/1`
* `eh String.to_integer/2` - Docs.for `String.to_integer/2`

## About

The project is inspired by ri (ruby interactive), that basically does
the same thing, but for ruby, and by `IEx.Helpers.h` in the `iex` shell.

Some of the code for extracting documentation from modules is more or
less borrowed straight out of `IEx.Introspection.h`.

## TODO

* `eh String.to_integer(some, args)` -> `String.to_integer/2`
* Support for code outside of Elixir core (my own projects, etc)
* Tests :(
