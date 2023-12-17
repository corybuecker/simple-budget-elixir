defmodule SimpleBudget.Account do
  use Ecto.Schema
  import Ecto.Changeset

  schema "accounts" do
    field :name, :string
    field :balance, :decimal
    field :debt, :boolean, default: false

    belongs_to :user, SimpleBudget.User

    timestamps(type: :utc_datetime)
  end

  def changeset(account, attrs \\ %{}) do
    account
    |> cast(attrs, [:name, :balance, :debt])
    |> validate_required([:name, :balance, :debt, :user_id])
    |> validate_number(:balance, greater_than_or_equal_to: 0)
    |> validate_inclusion(:debt, [true, false])
    |> assoc_constraint(:user)
  end
end
