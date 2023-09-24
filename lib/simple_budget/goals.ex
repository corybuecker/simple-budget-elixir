defmodule SimpleBudget.Goals do
  alias SimpleBudget.{User, Users, Goal, Repo, Account, Saving, Accounts, Goals, Savings}
  import Ecto, only: [build_assoc: 3]
  import Ecto.{Query}
  require Logger

  @type combined_records :: Account.t() | Saving.t() | Goal.t()

  @spec spendable(%{required(String.t()) => String.t()}) :: Decimal.t()
  def spendable(%{"identity" => identity}) do
    spendable_records(identity) |> spendable_total()
  end

  @spec spendable_records(String.t()) :: list(combined_records())
  def spendable_records(identity) do
    Accounts.all(%{"identity" => identity}) ++
      Goals.all(%{"identity" => identity}) ++ Savings.all(%{"identity" => identity})
  end

  def total_daily_amortized(records) do
    Enum.reduce(
      records,
      Decimal.new("0"),
      fn goal, total -> Decimal.add(total, Goal.daily_amortized_amount(goal)) end
    )
  end

  @spec spendable_total(list(Goal.t())) :: Decimal.t()
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
          Decimal.sub(acc, Goal.amortized_amount(goal))

        %Saving{} = saving, acc ->
          Decimal.sub(acc, saving.amount)
      end
    )
  end

  @spec spendable_today(%{required(String.t()) => String.t()}) :: Decimal.t()
  def spendable_today(%{"identity" => identity}) do
    total = spendable(%{"identity" => identity})

    days_left =
      case Date.diff(Date.end_of_month(today()), today()) do
        0 -> Date.diff(Date.end_of_month(tomorrow()), tomorrow())
        anything_else -> anything_else
      end

    Decimal.div(total, days_left)
  end

  @spec all(%{required(String.t()) => String.t()}) :: list(Goal.t())
  def all(%{"identity" => identity}) when is_bitstring(identity) do
    Repo.all(
      from g in Goal,
        join: u in User,
        on: u.id == g.user_id,
        where: u.identity == ^identity,
        select: g,
        order_by: g.name
    )
  end

  @spec all(SimpleBudget.User.t()) :: list(Goal.t())
  def all(%SimpleBudget.User{identity: identity}) when is_bitstring(identity) do
    all(%{"identity" => identity})
  end

  def delete(%{identity: identity}, %{"id" => id}) when is_bitstring(identity) do
    get(%{"identity" => identity}, %{"id" => id}) |> Repo.delete!()
  end

  def get(%{"identity" => identity}, %{"id" => id})
      when is_bitstring(identity) and is_bitstring(id) do
    Repo.one(
      from a in Goal,
        join: u in User,
        on: u.id == a.user_id,
        where: u.identity == ^identity and a.id == ^id,
        select: a
    )
  end

  def get(%{"identity" => identity}, %{}) when is_bitstring(identity) do
    Users.get_by_identity(identity) |> build_assoc(:goals, %{recurrance: :monthly})
  end

  def save(%Ecto.Changeset{data: %{id: nil}} = changeset) do
    Repo.insert!(changeset)
  end

  def save(%Ecto.Changeset{} = changeset) do
    Repo.update!(changeset)
  end

  def increment_target_date(%Goal{recurrance: :never} = goal) do
    goal |> Repo.delete!()
  end

  def increment_target_date(%Goal{} = goal) do
    with next_target_date <- Goal.next_target_date(goal) do
      Goal.changeset(goal, %{target_date: next_target_date}) |> save()
    end
  end

  defp today() do
    Application.get_env(:simple_budget, SimpleBudget.Goals)[:datetime_adapter].today()
  end

  defp tomorrow() do
    Application.get_env(:simple_budget, SimpleBudget.Goals)[:datetime_adapter].tomorrow()
  end
end
