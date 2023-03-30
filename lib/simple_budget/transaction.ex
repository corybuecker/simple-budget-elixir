defmodule SimpleBudget.Transaction do
  import Ecto.Changeset
  use Ecto.Schema

  schema "transactions" do
    field :amount, :decimal
    belongs_to :user, SimpleBudget.User
    timestamps()
  end

  def changeset(transaction, params \\ %{}) do
    transaction
    |> cast(params, [:amount])
    |> validate_required([:amount, :user_id])
  end
end
