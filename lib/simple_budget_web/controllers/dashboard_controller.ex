defmodule SimpleBudgetWeb.DashboardController do
  alias SimpleBudget.{Goals, Transactions}
  require Logger
  use SimpleBudgetWeb, :controller

  def show(conn, _params) do
    daily = Goals.spendable_today(get_session(conn))
    daily_added = Goals.total_daily_amortized(Goals.all(get_session(conn)))

    spent_today =
      Enum.reduce(
        Transactions.today(get_session(conn)),
        Decimal.new("0"),
        fn transaction, total -> Decimal.add(total, transaction.amount) end
      )

    days_left =
      case Date.diff(Date.end_of_month(today()), today()) do
        0 -> Date.diff(Date.end_of_month(tomorrow()), tomorrow())
        anything_else -> anything_else
      end

    conn
    |> render("show.html", %{
      daily: daily,
      page_title: "Dashboard",
      spendable_today: Decimal.sub(daily, spent_today),
      spent_today: spent_today,
      total: Goals.spendable(get_session(conn)),
      days: days_left,
      daily_added: daily_added,
      transactions_toggle: true
    })
  end

  defp today() do
    Application.get_env(:simple_budget, SimpleBudget.Goals)[:datetime_adapter].today()
  end

  defp tomorrow() do
    Application.get_env(:simple_budget, SimpleBudget.Goals)[:datetime_adapter].tomorrow()
  end

  def reset_transactions(conn, _params) do
    Transactions.clear_today(get_session(conn))

    conn |> redirect(to: "/")
  end
end
