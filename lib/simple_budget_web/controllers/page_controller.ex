defmodule SimpleBudgetWeb.PageController do
  use SimpleBudgetWeb, :controller

  def home(conn, _params) do
    accounts = SimpleBudget.User.accounts(conn |> get_session)
    savings = SimpleBudget.User.savings(conn |> get_session)
    goals = SimpleBudget.User.goals(conn |> get_session)

    spendable_today = SimpleBudget.Goals.spendable_today(accounts ++ savings ++ goals)
    spendable_total = SimpleBudget.Goals.spendable_total(accounts ++ savings ++ goals)
    total_daily_amortized = SimpleBudget.Goals.total_daily_amortized(goals)

    days_left =
      case Date.diff(Date.end_of_month(today()), today()) do
        0 -> Date.diff(Date.end_of_month(tomorrow()), tomorrow())
        anything_else -> anything_else
      end

    render(conn,
      spendable_today: spendable_today,
      spendable_total: spendable_total,
      days_left: days_left,
      total_daily_amortized: total_daily_amortized
    )
  end

  defp today do
    Application.get_env(:simple_budget, SimpleBudget.Goals)[:datetime_adapter].today()
  end

  defp tomorrow do
    Application.get_env(:simple_budget, SimpleBudget.Goals)[:datetime_adapter].tomorrow()
  end
end
