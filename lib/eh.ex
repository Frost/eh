defmodule Eh do
  @shortdoc "Lookup Elixir documentation from the command line"

  @moduledoc """
  Lookup Elixir documentation for Elixir terms.

  Eh works in the same way as Elixir's built-in IEx.Helpers.h, except that it
  exposes that functionality as a mix task.
  """

  # The main function has no @doc statement on purpose. The reason for this is
  # that I want to be able to test functions that has no documentation
  @doc false
  def main([definition | _tail]), do: lookup(definition)

  @doc """
  Lookup and print documentation on an Elixir term.

  This is intended to work like using `IEx.Helpers.h` in the `iex`
  shell, but without actually firing up `iex`.

  `definition` can be something like:

  * `String`
  * `String.to_integer`
  * `IO.ANSI.Docs.print`
  * `IO.ANSI.Docs.print/2`
  """
  def lookup(definition) do
    case docs(InputParser.parse(definition)) do
      :no_docs           -> IO.puts "No documentation for #{definition} was found"
      {:not_found, mod}  -> IO.puts "Could not load module #{mod}"
      {:ok, docs} ->
        for {title, doc} <- Enum.reverse(docs) do
          IO.ANSI.Docs.print_heading(title, monochrome_colors)
          IO.ANSI.Docs.print(doc, monochrome_colors)
        end
    end
  end

  # Find documentation for the specified {mod, fun, arity} tuple.
  #
  # Returns:
  # - {:not_found, mod} if the module does not exist
  # - {:no_docs, mod} if the module exists, but does not have docs
  # - {:ok, [doc...]} for all matching doc strings
  defp docs({nil, nil, nil}),
    do: :not_found
  # Retrieve documentation for a Module
  defp docs({mod, nil, nil}) do
    case Code.get_docs(mod, :moduledoc) do
      nil ->
        {:not_found, mod}
      {_, binary} when is_binary(binary) ->
        {:ok, [{"#{mod}", binary}]}
    end
  end
  # Try to find function in Kernel if mod is nil
  defp docs({nil, fun, arity}),
    do: docs({Kernel, fun, arity})
  # Retrieve documentation for a specific Module.function/arity
  # arity may be nil
  # The list comprehension here is borrowed from IEx.Introspection.
  defp docs(term) do
    case filter_docs(term) do
      nil ->
        {mod, _, _} = term
        {:not_found, mod}
      [] ->
        :no_docs
      results -> {:ok, results}
    end
  end

  # Filter out the relevant documentation chunks we need.
  #
  # Only include entries from Code.get_docs(mod, :docs) that:
  # 1. Have documentation
  # 2. Matches our fun/arity filter parameters
  # 3. If arity is nil, include everything that matches fun
  defp filter_docs({mod, fun, arity}) do
    case Code.get_docs(mod, :docs) do
      nil ->
        nil
      results ->
        results
        |> Enum.filter(fn (doc) -> filter_docs({fun, arity}, doc) end)
        |> Enum.map(fn (doc) -> reformat_doc(mod, doc) end)
    end
  end
  defp filter_docs(_filter, {_def, _ln, _tp, _args, nil}),
    do: false
  defp filter_docs(filter, {filter, _ln, _tp, _args, _doc}),
    do: true
  defp filter_docs({fun, nil}, {{fun, _arity}, _ln, _tp, _args, _doc}),
    do: true
  defp filter_docs(_filter, _doc),
    do: false

  # Reformat Elixir's internal structure to {{"Module.function/arity", doc}}
  defp reformat_doc(mod, {{fun, arity}, _ln, _tp, _args, doc}),
    do: {term({ mod, fun, arity }), doc}

  # Convert a {mod, fun, arity} tuple to a "Module.function/arity" string
  defp term({mod, fun, nil}),
    do: "#{mod}.#{fun}"
  defp term({mod, fun, arity}),
    do: "#{mod}.#{fun}/#{arity}"

  # Custom colors, kept in monochrome without any specific color choices, to
  # work well with both dark an bright terminals.
  defp monochrome_colors do
    [enabled: true,
      doc_bold: [:bright],
      doc_code: [:faint],
      doc_headings: [:underline],
      doc_inline_code: [:faint],
      doc_table_heading: [:reverse],
      doc_title: [:reverse, :bright],
      doc_underline: [:underline],
      width: 80]
  end
end
