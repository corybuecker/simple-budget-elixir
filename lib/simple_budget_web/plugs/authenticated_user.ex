defmodule SimpleBudgetWeb.Plugs.AuthenticatedUser do
  use SimpleBudgetWeb, :controller
  require Logger

  def init(options), do: options

  def call(conn, _opts) do
    with %{"identity" => identity} <- conn |> get_session(),
         true <-
           SimpleBudget.Users.existing_identity?(identity) do
      conn
    else
      _ -> conn |> redirect(to: "/login") |> halt()
    end
  end
end
