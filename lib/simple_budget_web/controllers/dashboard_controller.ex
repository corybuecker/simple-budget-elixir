defmodule SimpleBudgetWeb.DashboardController do
  alias SimpleBudget.{Goals, Transactions}
  require Logger
  use SimpleBudgetWeb, :controller

  def show(conn, _params) do
    daily = Goals.spendable_today(get_session(conn))

    spent_today =
      Enum.reduce(
        Transactions.today(get_session(conn)),
        Decimal.new("0"),
        fn transaction, total -> Decimal.add(total, transaction.amount) end
      )

    conn
    |> render("show.html", %{
      daily: daily,
      page_title: "Dashboard",
      spendable_today: Decimal.sub(daily, spent_today),
      spent_today: spent_today,
      total: Goals.spendable(get_session(conn)),
      transactions_toggle: true
    })
  end

  def reset_transactions(conn, _params) do
    Transactions.clear_today(get_session(conn))

    conn |> redirect(to: "/")
  end
end
