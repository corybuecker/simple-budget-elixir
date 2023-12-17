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

  pipeline :authenticated_user do
    plug SimpleBudgetWeb.Plugs.AuthenticatedUser
  end

  scope "/", SimpleBudgetWeb do
    pipe_through [:browser, :authenticated_user]

    get "/", PageController, :home

    resources "/accounts", AccountsController
    resources "/savings", SavingsController
    resources "/goals", GoalsController
  end

  scope "/login", SimpleBudgetWeb do
    pipe_through :browser

    get "/", LoginController, :new
    get "/callback", CallbackController, :new
  end

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
end
