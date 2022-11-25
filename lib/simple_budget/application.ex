defmodule SimpleBudget.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      SimpleBudget.Repo,
      # Start the Telemetry supervisor
      SimpleBudgetWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: SimpleBudget.PubSub},
      # Start the Endpoint (http/https)
      SimpleBudgetWeb.Endpoint,
      SimpleBudget.GoalConversionServer,
      {Cluster.Supervisor,
       [Application.get_env(:libcluster, :topologies), [name: MyApp.ClusterSupervisor]]}

      # Start a worker by calling: SimpleBudget.Worker.start_link(arg)
      # {SimpleBudget.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SimpleBudget.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SimpleBudgetWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
