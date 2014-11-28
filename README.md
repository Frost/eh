# Ei

Look up Elixir documentation from the command line

## How to use

`ei` basically works like `IEx.Helpers.h`, except that you can run it
from the command line.

It prints the documentation for its first argument, if it can find any
documentation on it.

Examples:

* `ei String`              - Module docs for `String`
* `ei String.to_integer`   - Docs for any arity of `String.to_integer`
* `ei String.to_integer/1` - Docs for `String.to_integer/1`
* `ei String.to_integer/2` - Docs.for `String.to_integer/2`

## TODO

* `ei String.to_integer(some, args)` -> `String.to_integer/2`
* Support for code outside of Elixir core (my own projects, etc)
* Tests :(
