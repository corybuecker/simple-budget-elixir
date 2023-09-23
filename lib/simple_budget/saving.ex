defmodule SimpleBudget.Saving do
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %SimpleBudget.Saving{
          name: String.t()
        }

  schema "savings" do
    field :name, :string
    field :amount, :decimal
    belongs_to :user, SimpleBudget.User

    timestamps()
  end

  def changeset(saving, params \\ %{}) do
    saving
    |> cast(params, [:name, :amount])
    |> validate_required([:name, :amount])
  end
end
