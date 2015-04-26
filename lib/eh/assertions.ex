defmodule Eh.Assertions do
  @moduledoc """
  Macros and helper functions Used for testing Eh
  """

  import ExUnit.Assertions
  import ExUnit.CaptureIO

  defmacro __using__(_options) do
    quote do
      import unquote(__MODULE__)
    end
  end

  def capture_eh(term) do
    capture_io(fn -> Eh.lookup(term) end)
  end

  def doc_match_regex(term) do
    ~r"\e\[0m\n\e\[7m\e\[1m + Elixir.#{term} +\e\[0m\n\e\[0m\n"
  end

  defmacro assert_no_docs(term) do
    quote bind_quoted: [term: term] do
      output = capture_eh(term)
      assert output =~ ~r(No documentation for #{term} was found$)
    end
  end

  defmacro assert_found_docs(definition, match \\ nil) do
    if !match, do: match = definition
    quote bind_quoted: [definition: definition, match: match] do
      output = capture_eh(definition)
      assert output =~ doc_match_regex(match)
    end
  end

  defmacro refute_found_docs(definition, match \\ nil) do
    if !match, do: match = definition
    quote bind_quoted: [definition: definition, match: match] do
      output = capture_eh(definition)
      refute output =~ doc_match_regex(match)
    end
  end

  defmacro assert_no_such_module(definition) do
    quote bind_quoted: [definition: definition] do
      output = capture_eh(definition)
      assert Regex.match?(~r(Could not load module Elixir.IDontExist), output)
    end
  end
end
