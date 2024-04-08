defmodule Pescarte.MixProject do
  use Mix.Project

  def project do
    [
      app: :pescarte,
      version: "0.1.0",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      elixirc_paths: elixirc_paths(Mix.env()),
      releases: [
        pescarte: [
          strip_beams: true,
          cookie: Base.url_encode64(:crypto.strong_rand_bytes(40)),
          validate_compile_env: true,
          quiet: true,
          include_erts: true,
          include_executables_for: [:unix]
        ]
      ]
    ]
  end

  def application do
    [mod: {Pescarte.Application, []}, extra_applications: [:logger]]
  end

  defp elixirc_paths(e) when e in [:dev, :test], do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:bandit, "~> 1.0"},
      {:nanoid, "~> 2.0"},
      {:bcrypt_elixir, "~> 2.0"},
      {:brcpfcnpj, "~> 1.0.0"},
      {:tesla, "~> 1.4"},
      {:finch, "~> 0.16"},
      {:jason, ">= 1.0.0"},
      {:ecto, "~> 3.10"},
      {:unzip, "~> 0.8"},
      {:nimble_parsec, "~> 1.3"},
      {:ecto_sql, "~> 3.4"},
      {:postgrex, ">= 0.0.0"},
      {:ex_machina, "~> 2.7.0"},
      {:phoenix, "~> 1.7", override: true},
      {:phoenix_ecto, "~> 4.1"},
      {:phoenix_html, "~> 3.3"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_view, "~> 0.20"},
      {:phoenix_storybook, "~> 0.5"},
      {:timex, "~> 3.0"},
      {:telemetry_metrics, "~> 0.4"},
      {:telemetry_poller, "~> 0.4"},
      {:floki, ">= 0.30.0"},
      {:lucide_icons, "~> 1.1"},
      {:hackney, "~> 1.20"},
      {:absinthe, "~> 1.5"},
      {:absinthe_plug, "~> 1.5"},
      {:absinthe_phoenix, "~> 2.0.0"},
      {:gettext, "~> 0.24"},
      {:faker, "~> 0.18", only: [:dev, :test]},
      {:esbuild, "~> 0.3", runtime: Mix.env() == :dev},
      {:tailwind, "~> 0.1", runtime: Mix.env() == :dev},
      {:dart_sass, "~> 0.5", runtime: Mix.env() == :dev},
      {:dialyxir, "~> 1.3", only: [:dev], runtime: false},
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false},
      {:ex_doc, "> 0.0.0", only: [:dev, :test], runtime: false},
      {:git_hooks, "~> 0.4.0", only: [:test, :dev], runtime: false}
    ]
  end

  defp aliases do
    [
      dev: ["setup", "phx.server"],
      setup: ["deps.get", "ecto.setup", "seed"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "seed"],
      "ecto.reset": ["ecto.drop", "ecto.setup", "seed"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"],
      "assets.build": [
        "esbuild default",
        "sass default",
        "tailwind default",
        "tailwind storybook"
      ],
      "assets.deploy": [
        "esbuild default --minify",
        "sass default",
        "tailwind default --minify",
        "tailwind storybook --minify",
        "phx.digest"
      ]
    ]
  end
end
