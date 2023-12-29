defmodule SimpleBudget.Goals do
  alias SimpleBudget.{Goal, Account, Saving}
  require Logger

  def total_daily_amortized(records) do
    Enum.reduce(
      records,
      Decimal.new("0"),
      fn goal, total -> Decimal.add(total, daily_amortized_amount(goal)) end
    )
  end

  def daily_amortized_amount(%SimpleBudget.Goal{} = goal) do
    Decimal.div(goal.amount, Decimal.new(days_to_amortize_across(goal)))
  end

  def spendable_total(records) do
    Enum.reduce(
      records,
      Decimal.new("0"),
      fn
        %Account{debt: false} = account, acc ->
          Decimal.add(account.balance, acc)

        %Account{debt: true} = account, acc ->
          Decimal.sub(acc, account.balance)

        %Goal{} = goal, acc ->
          Decimal.sub(acc, amortized_amount(goal))

        %Saving{} = saving, acc ->
          Decimal.sub(acc, saving.total)
      end
    )
  end

  @spec spendable_today(%{required(String.t()) => String.t()}) :: Decimal.t()
  def spendable_today(records) do
    total = spendable_total(records)

    days_left =
      case Date.diff(Date.end_of_month(today()), today()) do
        0 -> Date.diff(Date.end_of_month(tomorrow()), tomorrow())
        anything_else -> anything_else
      end

    Decimal.div(total, days_left)
  end

  @spec amortized_amount(Goal.t()) :: Decimal.t()
  def amortized_amount(%SimpleBudget.Goal{recurrance: :never} = goal) do
    seconds_to_amortize_across = seconds_to_amortize_across(goal)
    days_amortized = DateTime.diff(today(), DateTime.from_naive!(goal.inserted_at, "Etc/UTC"))

    amortized_amount =
      Decimal.mult(
        Decimal.div(goal.amount, Decimal.new(seconds_to_amortize_across)),
        Decimal.new(days_amortized)
      )

    Decimal.min(
      Decimal.max(
        amortized_amount,
        0
      ),
      goal.amount
    )
  end

  def amortized_amount(%SimpleBudget.Goal{} = goal) do
    start =
      goal.target_date
      |> DateTime.new!(~T[00:00:00])
      |> DateTime.add(-seconds_to_amortize_across(goal))

    start_diff = DateTime.diff(today(), start)

    Decimal.min(
      Decimal.max(
        0,
        Decimal.mult(
          Decimal.div(goal.amount, Decimal.new(seconds_to_amortize_across(goal))),
          Decimal.new(start_diff)
        )
      ),
      goal.amount
    )
  end

  @spec next_target_date(Goal.t()) :: Date.t()
  def next_target_date(%SimpleBudget.Goal{recurrance: :never} = goal) do
    goal.target_date
  end

  def next_target_date(%SimpleBudget.Goal{} = goal) do
    Date.add(goal.target_date, days_to_amortize_across(goal))
  end

  defp seconds_to_amortize_across(%Goal{} = goal) do
    days_to_amortize_across(goal) * 86_400
  end

  defp days_to_amortize_across(%Goal{
         recurrance: recurrance,
         initial_date: initial_date,
         target_date: target_date
       }) do
    case recurrance do
      :daily -> 1
      :weekly -> 7
      :monthly -> 30
      :yearly -> 365
      :never -> Date.diff(target_date, initial_date)
    end
  end

  defp today() do
    Application.get_env(:simple_budget, SimpleBudget.Goals)[:datetime_adapter].today()
  end

  defp tomorrow() do
    Application.get_env(:simple_budget, SimpleBudget.Goals)[:datetime_adapter].tomorrow()
  end
end
