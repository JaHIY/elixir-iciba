defmodule ICIBA.Mixfile do
  use Mix.Project

  def project do
    [app: :iciba,
     version: "0.1.0",
     elixir: "~> 1.3",
     escript: escript,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def escript do
    [
      main_module: ICIBA.CLI,
      embed_elixir: true,
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [
      applications: [
        :logger,
        :httpotion,
      ],
      mod: {
        ICIBA,
        []
      }
    ]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:httpotion, "~> 3.0.0"},
      {:poison, "~> 2.0"},
    ]
  end
end
