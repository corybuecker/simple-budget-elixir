defmodule SimpleBudget.Saving do
  use Ecto.Schema
  import Ecto.Changeset

  schema "savings" do
    field :name, :string
    field :amount, :decimal
    belongs_to :user, SimpleBudget.User

    timestamps()
  end

  def changeset(goal, params \\ %{}) do
    goal
    |> cast(params, [:name, :amount])
    |> validate_required([:name, :amount, :user_id])
  end
end
