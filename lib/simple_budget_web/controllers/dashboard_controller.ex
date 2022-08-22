defmodule SimpleBudgetWeb.DashboardController do
  alias SimpleBudget.{Accounts, Goals, Savings, Account, Goal, Saving}
  require Logger
  use SimpleBudgetWeb, :controller

  def show(conn, _params) do
    records =
      Accounts.all(get_session(conn)) ++
        Goals.all(get_session(conn)) ++ Savings.all(get_session(conn))

    total =
      Enum.reduce(
        records,
        Decimal.new("0"),
        fn
          %Account{debt: false} = account, acc ->
            Decimal.add(account.balance, acc)

          %Account{debt: true} = account, acc ->
            Decimal.sub(acc, account.balance)

          %Goal{} = goal, acc ->
            Logger.debug(goal |> inspect())
            Decimal.sub(acc, Goal.amortized_amount(goal))

          %Saving{} = saving, acc ->
            Decimal.sub(acc, saving.amount)
        end
      )

    days = Date.diff(Date.end_of_month(Date.utc_today()), Date.utc_today())

    daily =
      case Kernel.max(days, 1) do
        1 -> Decimal.div(total, 31)
        _ -> Decimal.div(total, Kernel.max(days, 1))
      end

    conn
    |> render("show.html", %{
      total: total,
      daily: daily,
      page_title: "Dashboard | Simple Budget"
    })
  end
end
