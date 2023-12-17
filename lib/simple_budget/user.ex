defmodule SimpleBudget.User do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias SimpleBudget.{Repo}

  schema "users" do
    field :email, :string
    field :identity, Ecto.UUID

    embeds_one :preferences, Preferences, on_replace: :update do
      field :layout, Ecto.Enum, values: [:grid, :list], default: :list
    end

    has_many :goals, SimpleBudget.Goal
    has_many :savings, SimpleBudget.Saving
    has_many :accounts, SimpleBudget.Account

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :identity])
    |> cast_embed(:preferences, required: true, with: &preferences_changeset/2)
    |> validate_required([:email, :identity])
  end

  defp preferences_changeset(preferences, attrs) do
    preferences
    |> cast(attrs, [:layout])
    |> validate_required([:layout])
    |> validate_inclusion(:layout, [:grid, :list])
  end

  def existing_identity?(identity) do
    from(u in SimpleBudget.User, where: u.identity == ^identity) |> SimpleBudget.Repo.exists?()
  end

  def get_by_email(email) do
    from(u in SimpleBudget.User, where: u.email == ^email) |> SimpleBudget.Repo.one()
  end

  def get_by_identity(identity) do
    from(u in SimpleBudget.User, where: u.identity == ^identity) |> SimpleBudget.Repo.one()
  end

  def accounts(%{"identity" => identity}) do
    query =
      from u in SimpleBudget.User,
        join: a in SimpleBudget.Account,
        on: a.user_id == u.id,
        where: u.identity == ^identity,
        select: a

    query |> Repo.all()
  end

  def accounts(%{"identity" => identity}, %{"id" => id}) do
    query =
      from u in SimpleBudget.User,
        join: a in SimpleBudget.Account,
        on: a.user_id == u.id,
        where: u.identity == ^identity and a.id == ^id,
        select: a

    query |> Repo.one()
  end

  def savings(%{"identity" => identity}) do
    query =
      from u in SimpleBudget.User,
        join: s in SimpleBudget.Saving,
        on: s.user_id == u.id,
        where: u.identity == ^identity,
        select: s

    query |> Repo.all()
  end

  def savings(%{"identity" => identity}, %{"id" => id}) do
    query =
      from u in SimpleBudget.User,
        join: s in SimpleBudget.Saving,
        on: s.user_id == u.id,
        where: u.identity == ^identity and s.id == ^id,
        select: s

    query |> Repo.one()
  end

  def goals(%{"identity" => identity}) do
    query =
      from u in SimpleBudget.User,
        join: g in SimpleBudget.Goal,
        on: g.user_id == u.id,
        where: u.identity == ^identity,
        select: g

    query |> Repo.all()
  end

  def goals(%{"identity" => identity}, %{"id" => id}) do
    query =
      from u in SimpleBudget.User,
        join: g in SimpleBudget.Goal,
        on: g.user_id == u.id,
        where: u.identity == ^identity and g.id == ^id,
        select: g

    query |> Repo.one()
  end
end
