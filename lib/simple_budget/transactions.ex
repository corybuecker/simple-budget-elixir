defmodule SimpleBudget.Transactions do
  alias SimpleBudget.{Repo, Users, User, Transaction}
  import Ecto, only: [build_assoc: 3]
  import Ecto.{Query}

  def today(%{"identity" => identity}) when is_bitstring(identity) do
    Repo.all(
      from t in Transaction,
        join: u in User,
        on: u.id == t.user_id,
        where:
          u.identity == ^identity and
            fragment("date(?)", t.inserted_at) == fragment("date(now())"),
        select: t
    )
  end

  def clear_today(%{"identity" => identity}) when is_bitstring(identity) do
    Repo.delete_all(
      from t in Transaction,
        join: u in User,
        on: u.id == t.user_id,
        where:
          u.identity == ^identity and
            fragment("date(?)", t.inserted_at) == fragment("date(now())"),
        select: t
    )
  end

  def get(%{"identity" => identity}) when is_bitstring(identity) do
    Users.get_by_identity(identity) |> build_assoc(:transactions, %{})
  end

  def save(%Ecto.Changeset{data: %{id: nil}} = changeset) do
    Repo.insert!(changeset)
  end
end
