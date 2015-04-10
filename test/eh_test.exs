defmodule EhTest do
  use ExUnit.Case

  import ExUnit.CaptureIO

  defp capture_eh(term) do
    capture_io(fn -> Eh.lookup(term) end)
  end

  defp no_docs(term) do
    output = capture_eh(term)
    Regex.match?(~r(No documentation for #{term} was found$), output)
  end

  defp found_docs_for(definition, match \\ nil) do
    if !match, do: match = definition
    output = capture_eh(definition)
    Regex.match?(doc_match_regex(match), output)
  end

  defp doc_match_regex(term) do
    ~r"\e\[0m\n\e\[7m\e\[1m + Elixir.#{term} +\e\[0m\n\e\[0m\n"
  end

  test "find docs for Kernel function without module definition" do
    assert found_docs_for("is_binary", "Kernel.is_binary/1")
  end

  test "find no docs for a non-existing kernel function" do
    assert no_docs("i_dont_exist")
  end

  test "find docs for existing module" do
    assert found_docs_for("String")
  end

  test "find no docs for a non-existing module" do
    output = capture_eh("IDontExist")
    assert Regex.match?(~r(Could not load module Elixir.IDontExist), output)
  end

  test "find all docs for a module and function pair" do
    assert found_docs_for("String.to_integer", "String.to_integer/1")
    assert found_docs_for("String.to_integer", "String.to_integer/2")
  end

  test "find no docs for a non-existing module/function pair" do
    assert no_docs("Module.i_dont_exist")
  end

  test "find docs for a specific module, function and arity" do
    assert found_docs_for("String.to_integer/1")
    refute found_docs_for("String.to_integer/1", "String.to_integer/2")
  end

  test "find no docs for a non-existing module/function/arity" do
    assert no_docs("String.to_integer/0")
  end

  test "find no docs for a function lacking documentation" do
    assert no_docs("Eh.main")
  end

  test "find docs for a nested module" do
    assert found_docs_for("IO.ANSI")
  end

  test "find docs for a function in a nested module" do
    assert found_docs_for("IO.ANSI.Docs.print", "IO.ANSI.Docs.print/2")
  end
end
