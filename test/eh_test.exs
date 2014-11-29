defmodule EhTest do
  use ExUnit.Case

  import ExUnit.CaptureIO

  defp capture_eh(term) do
    capture_io(fn -> Eh.main([term]) end)
  end

  defp doc_match_regex(term) do
    head = ~r"\e\[0m\n\e\[7m\e\[1m + Elixir.#{term} +\e\[0m\n\e\[0m\n"
  end

  test "find docs for Kernel function without module definition" do
    output = capture_eh("is_binary")
    assert(Regex.match?(doc_match_regex("Kernel.is_binary/1"), output))
  end

  test "find no docs for a non-existing kernel function" do
    output = capture_eh("i_dont_exist")
    assert Regex.match?(~r/i_dont_exist not found$/, output)
  end

  test "find docs for existing module" do
    output = capture_eh("String")
    assert(Regex.match?(doc_match_regex("String"), output))
  end

  test "find no docs for a non-existing module" do
    output = capture_eh("IDontExist")
    assert Regex.match?(~r/IDontExist not found$/, output)
  end

  test "find all docs for a module and function pair" do
    output = capture_eh("String.to_integer")
    assert(Regex.match?(doc_match_regex("String.to_integer/1"), output))
    assert(Regex.match?(doc_match_regex("String.to_integer/2"), output))
  end

  test "find no docs for a non-existing module/function pair" do
    output = capture_eh("Module.i_dont_exist")
    assert Regex.match?(~r/Module.i_dont_exist not found$/, output)
  end

  test "find docs for a specific module, function and arity" do
    output = capture_eh("String.to_integer/1")
    assert(Regex.match?(doc_match_regex("String.to_integer/1"), output))
    refute(Regex.match?(doc_match_regex("String.to_integer/2"), output))
  end

  test "find no docs for a non-existing module/function/arity" do
    output = capture_eh("String.to_integer/0")
    assert Regex.match?(~r/String.to_integer\/0 not found$/, output)
  end

  test "find docs for a nested module" do
    output = capture_eh("IO.ANSI")
    assert(Regex.match?(doc_match_regex("IO.ANSI"), output))
  end

  test "find docs for a function in a nested module" do
    output = capture_eh("IO.ANSI.Docs.print")
    assert(Regex.match?(doc_match_regex("IO.ANSI.Docs.print/2"), output))
  end
end
