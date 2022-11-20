defmodule SimpleBudget.Goals do
  alias SimpleBudget.{User, Users, Goal, Repo, Account, Saving, Accounts, Goals, Savings}
  import Ecto, only: [build_assoc: 3]
  import Ecto.{Query}
  require Logger

  def spendable(%{"identity" => identity}) do
    records =
      Accounts.all(%{"identity" => identity}) ++
        Goals.all(%{"identity" => identity}) ++ Savings.all(%{"identity" => identity})

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
  end

  def spendable_today(%{"identity" => identity}) do
    total = spendable(%{"identity" => identity})
    days = Date.diff(Date.end_of_month(today()), today())

    case Kernel.max(days, 0) do
      0 -> total
      _ -> Decimal.div(total, Kernel.max(days, 1))
    end
  end

  def spendable_today(%{"identity" => _identity}, total) do
    days = Date.diff(Date.end_of_month(today()), today())

    case Kernel.max(days, 0) do
      0 -> total
      _ -> Decimal.div(total, Kernel.max(days, 1))
    end
  end

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

  def all(%{identity: identity}) when is_bitstring(identity) do
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

  defp today() do
    Application.get_env(:simple_budget, SimpleBudget.Goals)[:date_adapter].today()
  end
end
