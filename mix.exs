defmodule Probex.MixProject do
  use Mix.Project

  def project do
    [
      app: :probex,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {Probex.Application, []}
    ]
  end

  defp deps do
    [
      {:plug_cowboy, "~> 2.0"}
    ]
  end
end
