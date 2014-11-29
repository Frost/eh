defmodule Eh do
  def main([definition | _tail]) do
    {mod, fun, arity} = parse_input(definition)
    case docs(mod, fun, arity) do
      {:no_docs, term}   -> IO.puts "#{term} was not compiled with docs"
      {:not_found, term} -> IO.puts "#{term} not found"
      {:ok, results}     ->
        for {title, doc} <- results do
          IO.ANSI.Docs.print_heading(title, monochrome_colors)
          IO.ANSI.Docs.print(doc, monochrome_colors)
        end
    end
  end

  # Retrieve documentation for a Module
  defp docs(mod, nil, nil) do
    case docs = Code.get_docs(mod, :moduledoc) do
      {_, binary} when is_binary(binary)  -> {:ok, [{"#{mod}", binary}]}
      {message, term}                     -> {:not_found, term}
    end
  end

  # Try to find function in Kernel if mod is nil
  defp docs(nil, fun, arity) do
    docs(Kernel, fun, arity)
  end

  # Retrieve documentation for all definitions of a Module.function
  # The list comprehension here is borrowed from IEx.Introspection.
  defp docs(mod, fun, nil) do
    term = "#{mod}.#{fun}"
    if docs = Code.get_docs(mod, :docs) do
      result = for {{f, arity}, _ln, _tp, _a, doc} <- docs, f == fun, !!doc do
        { "#{term}/#{arity}", doc }
      end
      if result !=  [], do: {:ok, result}, else: {:not_found, term}
    else
      {:no_docs, term}
    end
  end

  # Retrieve documentation for a specific Module.function/arity
  defp docs(mod, fun, arity) do
    term = "#{mod}.#{fun}/#{arity}"
    if docs = Code.get_docs(mod, :docs) do
      result = for {{f, a}, _ln, _tp, _a, doc} <- docs, f == fun, a == arity, !!doc do
        { "#{mod}.#{fun}/#{arity}", doc }
      end
      if result !=  [], do: {:ok, result}, else: {:not_found, term}
    else
      {:no_docs, term}
    end
  end

  defp parse_input(definition) do
    parts = String.split(definition, ".")
    mod = find_module(parts)
    {fun, arity} = find_function_and_arity(parts)
    {mod, fun, arity}
  end

  # From a list of parts, find a loaded module
  # example: input: ["IO", "ANSI", "Docs", "print"] -> IO.ANSI.Docs
  # example: input: ["String", "to_atom"]           -> String
  defp find_module(parts) when parts == [] do
    nil
  end

  defp find_module(parts) do
    mod = Module.concat(parts)
    case Code.ensure_loaded?(mod) do
      true -> mod
      false -> find_module(List.delete(parts, List.last(parts)))
    end
  end

  # extracts function and arity
  # example: input: ["IO", "ANSI", "Docs", "print"]   -> {:print, nil}
  # example: input: ["String", "to_atom"]             -> {:to_atom, nil}
  # example: input: ["IO", "ANSI", "Docs", "print/2"] -> {:print, 2}
  # example: input: ["String", "to_atom/1"]           -> {:to_atom, 1}
  defp find_function_and_arity(parts) do
    mod = Module.concat(parts)
    case Code.ensure_loaded?(mod) do
      true -> {nil, nil}
      false ->
        fun_arity_regex = ~r/^(?<fun>[^.\/]+)(?:\/(?<arity>\d+))?$/
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
