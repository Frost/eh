defmodule InputParser do

  @shortdoc "Convert Module.function/arity -> {Module, function, arity}"

  @moduledoc """
  Parse input from a string definition of a function, into a tuple with
  {Module, function, arity}, so that it can be used for documentation
  lookup.
  """

  @doc """
  Parse input from a string definition of a function, into a tuple with
  {Module, function, arity}, so that it can be used for documentation
  lookup.


      Examples:

      iex> InputParser.parse("String.to_integer")
      {String, :to_integer, nil}

      iex> InputParser.parse("String.to_integer/2")
      {String, :to_integer, 2}

      iex> InputParser.parse("is_binary")
      {Kernel, :is_binary, nil}

      iex> InputParser.parse("IO.ANSI.Docs.print/2")
      {IO.ANSI.Docs, :print, 2}

      iex> InputParser.parse("InputParser")
      {InputParser, nil, nil}

      iex> InputParser.parse("IDontExist")
      {IDontExist, nil, nil}
  """
  def parse(definition) do
    parts = String.split(definition, ".")
    {mod, fun} = Enum.partition(parts, &Regex.match?(~r/^[A-Z]/, &1))
    {fun, arity} = find_function_and_arity(fun)
    {find_module(mod), fun, arity}
  end

  # From a list of parts, find a loaded module
  # example: input: ["IO", "ANSI", "Docs", "print"] -> IO.ANSI.Docs
  # example: input: ["String", "to_atom"]           -> String
  defp find_module(parts) when parts == [],
    do: Kernel
  defp find_module(parts),
    do: Module.concat(parts)

  # extracts function and arity
  # example: input: ["IO", "ANSI", "Docs", "print"]   -> {:print, nil}
  # example: input: ["String", "to_atom"]             -> {:to_atom, nil}
  # example: input: ["IO", "ANSI", "Docs", "print/2"] -> {:print, 2}
  # example: input: ["String", "to_atom/1"]           -> {:to_atom, 1}
  defp find_function_and_arity(parts) do
    case Enum.reject(parts, &Regex.match?(~r(^[A-Z]), &1)) do
      [] ->
        {nil, nil}
      parts ->
        fun_arity_regex = ~r/^(?<fun>[a-z_]+)(?:\/(?<arity>\d+))?$/
        matches = Regex.named_captures(fun_arity_regex, List.last(parts))
        %{"arity" => arity, "fun" => fun} = matches

        if arity == "" do
          arity = nil
        else
          arity = String.to_integer(arity)
        end

        {String.to_atom(fun), arity}
    end
  end
end
