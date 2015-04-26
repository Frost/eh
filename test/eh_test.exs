defmodule EhTest do
  use ExUnit.Case
  use Eh.Assertions

  test "find docs for Kernel function without module definition" do
    assert_found_docs("is_binary", "Kernel.is_binary/1")
  end

  test "find no docs for a non-existing kernel function" do
    assert_no_docs("i_dont_exist")
  end

  test "find docs for existing module" do
    assert_found_docs("String")
  end

  test "find no docs for a non-existing module" do
    assert_no_such_module("IDontExist")
  end

  test "find all docs for a module and function pair" do
    assert_found_docs("String.to_integer", "String.to_integer/1")
    assert_found_docs("String.to_integer", "String.to_integer/2")
  end

  test "find no docs for a non-existing module/function pair" do
    assert_no_docs("Module.i_dont_exist")
  end

  test "find docs for a specific module, function and arity" do
    assert_found_docs("String.to_integer/1")
    refute_found_docs("String.to_integer/1", "String.to_integer/2")
  end

  test "find no docs for a non-existing module/function/arity" do
    assert_no_docs("String.to_integer/0")
  end

  test "find no docs for a function lacking documentation" do
    assert_no_docs("Eh.main")
  end

  test "find docs for a nested module" do
    assert_found_docs("IO.ANSI")
  end

  test "find docs for a function in a nested module" do
    assert_found_docs("IO.ANSI.Docs.print", "IO.ANSI.Docs.print/2")
  end

  test "Eh.functions lists public functions in a module" do
    output = Eh.functions("Eh")
    assert output == [
      "Elixir.Eh.functions/1",
      "Elixir.Eh.lookup/1",
      "Elixir.Eh.main/1"
    ]
  end

  @tag :pending
  test "lists public methods in modules" do
    output = capture_eh("Eh")
    assert output =~ "Public functions:"
  end
end
