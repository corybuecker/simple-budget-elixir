defmodule SimpleBudgetWeb.LoginController do
  use SimpleBudgetWeb, :controller
  require Logger

  def new(conn, _params) do
    config =
      Assent.Strategy.Google.default_config([])
      |> Assent.Config.merge(config())

    {:ok, %{session_params: session_params, url: url}} =
      Assent.Strategy.Google.authorize_url(config)

    conn
    |> put_session(:google_session_params, session_params)
    |> redirect(external: url)
    |> halt()
  end

  defp config() do
    [
      client_id: System.get_env("GOOGLE_CLIENT_ID"),
      http_adapter: Assent.HTTPAdapter.Mint,
      redirect_uri: System.get_env("GOOGLE_CALLBACK_URL"),
      authorization_params: [scope: "openid email"]
    ]
  end
end
