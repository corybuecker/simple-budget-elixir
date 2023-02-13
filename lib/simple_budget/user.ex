defmodule SimpleBudget.User do
  require Logger
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :identity, Ecto.UUID

    embeds_one :preferences, Preferences, on_replace: :update do
      field :accounts_layout, Ecto.Enum, values: [:grid, :list]
      field :goals_layout, Ecto.Enum, values: [:grid, :list]
      field :savings_layout, Ecto.Enum, values: [:grid, :list]
    end

    has_many :accounts, SimpleBudget.Account
    has_many :goals, SimpleBudget.Goal
    has_many :savings, SimpleBudget.Saving

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
    |> cast(params, [:accounts_layout, :savings_layout, :goals_layout])
    |> validate_inclusion(:accounts_layout, [:grid, :list])
    |> validate_inclusion(:savings_layout, [:grid, :list])
    |> validate_inclusion(:goals_layout, [:grid, :list])
  end
end
