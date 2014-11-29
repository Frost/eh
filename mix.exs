defmodule Eh.Mixfile do
  use Mix.Project

  def project do
    [app: :eh,
     version: "0.0.1",
     elixir: "~> 1.1-dev",
     escript: [main_module: Eh],
     deps: []]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger]]
  end
end
