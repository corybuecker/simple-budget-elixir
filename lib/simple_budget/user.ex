defmodule SimpleBudget.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :identity, Ecto.UUID
    has_many :accounts, SimpleBudget.Account
    has_many :goals, SimpleBudget.Goal
    has_many :savings, SimpleBudget.Saving

    timestamps()
  end

  def changeset(user, params \\ %{}) do
    user
    |> cast(params, [:email])
    |> validate_required([:email])
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
  end
end
