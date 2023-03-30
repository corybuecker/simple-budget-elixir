defmodule SimpleBudget.User do
  require Logger
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :identity, Ecto.UUID

    embeds_one :preferences, Preferences, on_replace: :update do
      field :layout, Ecto.Enum, values: [:grid, :list], default: :list
    end

    has_many :accounts, SimpleBudget.Account
    has_many :goals, SimpleBudget.Goal
    has_many :savings, SimpleBudget.Saving
    has_many :transactions, SimpleBudget.Transaction

    timestamps()
  end

  def changeset(user, params \\ %{}) do
    user
    |> cast(params, [:email])
    |> cast_embed(:preferences, with: &preferences_changeset/2)
    |> validate_required([:email])
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
  end

  defp preferences_changeset(schema, params) do
    schema
    |> cast(params, [:layout])
    |> set_optional_layouts_to_defaults()
    |> validate_inclusion(:layout, [:grid, :list])
  end

  defp set_optional_layouts_to_defaults(%Ecto.Changeset{} = changeset) do
    Enum.reduce([:layout], changeset, fn key, changeset ->
      case changeset |> Ecto.Changeset.get_field(key, nil) do
        nil ->
          changeset
          |> Ecto.Changeset.put_change(key, :list)

        _ ->
          changeset
      end
    end)
  end
end
