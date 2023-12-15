defmodule SimpleBudgetWeb.Router do
  use SimpleBudgetWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {SimpleBudgetWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :authorized do
    plug SimpleBudgetWeb.Plugs.AuthenticatedUser
  end

  scope "/", SimpleBudgetWeb do
    pipe_through [:browser, :authorized]

    get "/", DashboardController, :show
    get "/transactions", DashboardController, :reset_transactions

    live "/accounts", AccountLive.Index
    live "/accounts/new", AccountLive.Edit
    live "/accounts/:id", AccountLive.Edit

    live "/goals", GoalLive.Index
    live "/goals/new", GoalLive.Edit
    live "/goals/:id", GoalLive.Edit

    live "/savings", SavingLive.Index
    live "/savings/new", SavingLive.Edit
    live "/savings/:id", SavingLive.Edit

    live "/transactions/new", TransactionsLive.Edit

    live "/dashboard", DashboardLive.Index
  end

  scope "/login", SimpleBudgetWeb do
    pipe_through [:browser]

    get "/", LoginController, :new
    get "/callback", CallbackController, :new
  end

  # Other scopes may use custom stacks.
  # scope "/api", SimpleBudgetWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:simple_budget, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: SimpleBudgetWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  def handle_errors(_conn, %{kind: kind, reason: reason, stack: stacktrace}) do
    Rollbax.report(kind, reason, stacktrace)
  end
end
