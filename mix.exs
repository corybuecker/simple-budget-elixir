defmodule SimpleBudget.MixProject do
  use Mix.Project

  def project do
    [
      aliases: aliases(),
      app: :simple_budget,
      compilers: Mix.compilers(),
      deps: deps(),
      elixir: "1.14.3",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      test_coverage: [
        ignore_modules: [
          SimpleBudget.DataCase,
          SimpleBudgetWeb,
          SimpleBudget.Application,
          SimpleBudgetWeb.Gettext,
          SimpleBudgetWeb.Router,
          SimpleBudgetWeb.Telemetry,
          SimpleBudgetWeb.ErrorHelpers,
          SimpleBudget.Repo
        ]
      ],
      version: "0.1.0"
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {SimpleBudget.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:assent, "~> 0.2.0"},
      {:castore, "~> 0.1.0"},
      {:dialyxir, "~> 1.0", only: [:dev, :test], runtime: false},
      {:ecto_sql, "~> 3.6"},
      {:esbuild, "~> 0.7", runtime: Mix.env() == :dev},
      {:floki, ">= 0.30.1", only: :test},
      {:gettext, "~> 0.22"},
      {:jason, "~> 1.2"},
      {:mint, "~> 1.0"},
      {:number, "~> 1.0"},
      {:phoenix_ecto, "~> 4.4"},
      {:phoenix_html, "~> 3.3.0"},
      {:phoenix_live_dashboard, "~> 0.7.0"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_view, "~> 0.18.13"},
      {:phoenix, "~> 1.7.0"},
      {:plug_cowboy, "~> 2.5"},
      {:postgrex, ">= 0.0.0"},
      {:swoosh, "~> 1.9.1"},
      {:tailwind, "~> 0.2.0", runtime: Mix.env() == :dev},
      {:telemetry_metrics, "~> 0.6"},
      {:telemetry_poller, "~> 1.0"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "assets.deploy": ["esbuild default --minify", "phx.digest"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      setup: ["deps.get", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"]
    ]
  end
end
