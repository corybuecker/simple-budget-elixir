defmodule SimpleBudget.Transactions do
  alias SimpleBudget.{
    Repo,
    Transaction,
    User,
    Users
  }

  import Ecto, only: [build_assoc: 3]
  import Ecto.{Query}

  def today(%{"identity" => identity}) when is_bitstring(identity) do
    Repo.all(
      from t in Transaction,
        join: u in User,
        on: u.id == t.user_id,
        where:
          u.identity == ^identity and
            fragment("date(?)", t.inserted_at) == fragment("date(now())") and t.archived == false,
        select: t
    )
  end

  def clear_today(%{"identity" => identity}) when is_bitstring(identity) do
    from(t in Transaction,
      join: u in User,
      on: u.id == t.user_id,
      where:
        u.identity == ^identity and
          fragment("date(?)", t.inserted_at) == fragment("date(now())"),
      select: t,
      update: [set: [archived: true]]
    )
    |> Repo.update_all([])
  end

  def get(%{"identity" => identity}) when is_bitstring(identity) do
    Users.get_by_identity(identity) |> build_assoc(:transactions, %{})
  end

  def save(%Ecto.Changeset{data: %{id: nil}} = changeset) do
    Repo.insert!(changeset)
  end
end
