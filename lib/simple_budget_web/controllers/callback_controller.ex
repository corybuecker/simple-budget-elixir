defmodule SimpleBudgetWeb.CallbackController do
  use SimpleBudgetWeb, :controller
  require Logger
  alias Assent.Strategy.{Google}

  def new(conn, params) do
    with {:ok, %{user: %{"email" => email, "email_verified" => true}}} <- callback(conn, params),
         %SimpleBudget.User{identity: identity} <- SimpleBudget.User.get_by_email(email) do
      conn
      |> delete_session(:google_session_params)
      |> put_session(:identity, identity)
      |> redirect(to: "/")
      |> halt()
    else
      _ -> conn |> put_status(400) |> text("Error")
    end
  end

  defp callback(conn, params) do
    Google.default_config([])
    |> Assent.Config.merge(config())
    |> Assent.Config.put(:session_params, conn |> get_session(:google_session_params))
    |> Google.callback(params)
    |> log_passthrough()
  end

  defp config do
    [
      authorization_params: [scope: "openid email"],
      client_id: System.get_env("GOOGLE_CLIENT_ID"),
      client_secret: System.get_env("GOOGLE_CLIENT_SECRET"),
      http_adapter: Assent.HTTPAdapter.Mint,
      redirect_uri: System.get_env("GOOGLE_CALLBACK_URL")
    ]
  end

  def log_passthrough(anything) do
    Logger.debug(anything |> inspect())
    anything
  end
end
