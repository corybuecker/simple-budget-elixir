defmodule SimpleBudgetWeb.LoginController do
  use SimpleBudgetWeb, :controller
  require Logger
  alias Assent.Strategy.Google

  def new(conn, _params) do
    config =
      Google.default_config([])
      |> Assent.Config.merge(config())

    {:ok, %{session_params: session_params, url: url}} =
      Google.authorize_url(config)

    conn
    |> put_session(:google_session_params, session_params)
    |> redirect(external: url)
    |> halt()
  end

  defp config do
    [
      authorization_params: [scope: "openid email"],
      client_id: System.get_env("GOOGLE_CLIENT_ID"),
      http_adapter: Assent.HTTPAdapter.Mint,
      redirect_uri: System.get_env("GOOGLE_CALLBACK_URL")
    ]
  end
end
