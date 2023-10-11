defmodule SimpleBudget.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    cluster_configuration =
      {Cluster.Supervisor,
       [
         [
           erlang_nodes_in_k8s: [
             strategy: Elixir.Cluster.Strategy.Kubernetes.DNS,
             config: [
               service: "simple-budget-headless",
               application_name: "simple-budget"
             ]
           ]
         ],
         [name: SimpleBudget.ClusterSupervisor]
       ]}

    base_children = [
      # Start the Telemetry supervisor
      SimpleBudgetWeb.Telemetry,
      # Start the Ecto repository
      SimpleBudget.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: SimpleBudget.PubSub},
      # Start Finch
      {Finch, name: SimpleBudget.Finch},
      # Start the Endpoint (http/https)
      SimpleBudgetWeb.Endpoint,
      # Start a worker by calling: SimpleBudget.Worker.start_link(arg)
      # {SimpleBudget.Worker, arg}
      SimpleBudget.GoalConversionServer
    ]

    children =
      if Application.get_env(:simple_budget, :cluster) do
        base_children ++ [cluster_configuration]
      else
        base_children
      end

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
