defmodule SimpleBudgetWeb.DashboardController do
  alias SimpleBudget.Goals
  require Logger
  use SimpleBudgetWeb, :controller

  def show(conn, _params) do
    conn
    |> render("show.html", %{
      total: Goals.spendable(get_session(conn)),
      daily: Goals.spendable_today(get_session(conn)),
      page_title: "Dashboard"
    })
  end
end
