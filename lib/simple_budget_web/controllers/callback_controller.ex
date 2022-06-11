defmodule SimpleBudgetWeb.CallbackController do
  use SimpleBudgetWeb, :controller
  require Logger

  def new(conn, params) do
    with {:ok, %{user: %{"email" => email, "email_verified" => true}}} <- callback(conn, params),
         %SimpleBudget.User{identity: identity} <- SimpleBudget.Users.get_by_email(email) do
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
    Assent.Strategy.Google.default_config([])
    |> Assent.Config.merge(config())
    |> Assent.Config.put(:session_params, conn |> get_session(:google_session_params))
    |> Assent.Strategy.Google.callback(params)
  end

  defp config() do
    [
      client_id: System.get_env("GOOGLE_CLIENT_ID"),
      client_secret: System.get_env("GOOGLE_CLIENT_SECRET"),
      http_adapter: Assent.HTTPAdapter.Mint,
      redirect_uri: System.get_env("GOOGLE_CALLBACK_URL"),
      authorization_params: [scope: "openid email"]
    ]
  end
end
