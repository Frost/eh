defmodule Eh.Mixfile do
  use Mix.Project

  def project do
    [app: :eh,
     version: "0.1.0",
     elixir: "~> 1.0.0",
     escript: [main_module: Eh],
     description: description,
     package: package,
     deps: []]
  end

  def application do
    []
  end

  defp description do
    """
    Lookup Elixir documentation from the command line
    """
  end

  defp package do
    [ files: ~w[ lib README.md mix.exs LICENCE ],
      contributors: ["Martin Frost"],
      licenses: ["Apache 2.0"],
      links: %{ "GitHub" => "https://github.com/Frost/eh.git" } ]
  end
end
