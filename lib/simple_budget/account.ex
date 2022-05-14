defmodule SimpleBudget.Account do
  use Ecto.Schema
  import Ecto.Changeset

  schema "accounts" do
    field :name, :string
    field :balance, :decimal
    field :debt, :boolean

    belongs_to :user, SimpleBudget.User

    timestamps()
  end

  def changeset(account, params \\ %{}) do
    account
    |> cast(params, [:name, :balance, :debt])
    |> validate_required([:name, :balance, :debt])
  end
end
