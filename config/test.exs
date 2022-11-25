import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :simple_budget, SimpleBudget.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "simple_budget_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :simple_budget, SimpleBudgetWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "8m7MfLhzsxiTi+urC6lW3ThbmlNX9cElC3h4SdPPCySm9LGEeLQKSK+mpK9sURD6",
  server: false

# In test we don't send emails.
config :simple_budget, SimpleBudget.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

config :simple_budget, SimpleBudget.Goals, date_adapter: SimpleBudget.Utilities.FakeDate

config :libcluster,
  topologies: [
    local_epmd: [
      strategy: Elixir.Cluster.Strategy.Epmd
    ]
  ]
