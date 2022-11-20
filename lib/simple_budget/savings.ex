defmodule SimpleBudget.Savings do
  alias SimpleBudget.{User, Users, Saving, Repo}
  import Ecto, only: [build_assoc: 3]
  import Ecto.{Query}
  require Logger

  def all(%{"identity" => identity}) when is_bitstring(identity) do
    Repo.all(
      from a in Saving,
        join: u in User,
        on: u.id == a.user_id,
        where: u.identity == ^identity,
        select: a
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
      from a in Saving,
        join: u in User,
        on: u.id == a.user_id,
        where: u.identity == ^identity and a.id == ^id,
        select: a
    )
  end

  def get(%{"identity" => identity}, %{}) when is_bitstring(identity) do
    Users.get_by_identity(identity) |> build_assoc(:savings, %{})
  end

  def save(%Ecto.Changeset{data: %{id: nil}} = changeset) do
    Repo.insert!(changeset)
  end

  def save(%Ecto.Changeset{} = changeset) do
    Repo.update!(changeset)
  end
end
