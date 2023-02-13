defmodule SimpleBudgetWeb.DashboardController do
  alias SimpleBudget.Goals
  require Logger
  use SimpleBudgetWeb, :controller

  def show(conn, _params) do
    goals = Goals.all(get_session(conn))

    conn
    |> render("show.html", %{
      total: Goals.spendable(get_session(conn)),
      daily:
        Decimal.sub(Goals.spendable_today(get_session(conn)), Goals.total_daily_amortized(goals)),
      page_title: "Dashboard"
    })
  end
end
