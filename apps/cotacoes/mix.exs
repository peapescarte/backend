defmodule Cotacoes.MixProject do
  use Mix.Project

  def project do
    [
      app: :cotacoes,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:ecto_sql, "~> 3.4"},
      {:postgrex, ">= 0.0.0"},
      {:ex_machina, "~> 2.7.0"},
      {:database, in_umbrella: true}
    ]
  end
end
