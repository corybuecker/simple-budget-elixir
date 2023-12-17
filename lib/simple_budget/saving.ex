defmodule SimpleBudget.Saving do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias SimpleBudget.{Repo}

  schema "savings" do
    field :name, :string
    field :total, :decimal
    belongs_to :user, SimpleBudget.User
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(saving, attrs \\ %{}) do
    saving
    |> cast(attrs, [:name, :total])
    |> validate_required([:name, :total, :user_id])
    |> validate_number(:total, greater_than_or_equal_to: 0)
    |> assoc_constraint(:user)
  end

  def list_savings do
    from(s in SimpleBudget.Saving, order_by: [asc: s.name])
    |> Repo.all()
  end
end
