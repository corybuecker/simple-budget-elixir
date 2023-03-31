defmodule SimpleBudget.Transaction do
  import Ecto.Changeset
  use Ecto.Schema

  schema "transactions" do
    field :amount, :decimal
    field :archived, :boolean, default: false

    belongs_to :user, SimpleBudget.User

    timestamps()
  end

  def changeset(transaction, params \\ %{}) do
    transaction
    |> cast(params, [:amount, :archived])
    |> validate_required([:amount, :user_id, :archived])
  end
end
