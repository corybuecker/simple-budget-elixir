defmodule SimpleBudget.Goal do
  import Ecto.Changeset
  use Ecto.Schema

  schema "goals" do
    field :name, :string
    field :amount, :decimal
    field :recurrance, Ecto.Enum, values: [:daily, :weekly, :monthly, :yearly]
    field :initial_date, :date
    field :target_date, :date
    belongs_to :user, SimpleBudget.User
    timestamps(type: :utc_datetime)
  end

  def changeset(goal, attrs \\ %{}) do
    goal
    |> cast(attrs, [:name, :amount, :recurrance, :target_date, :initial_date])
    |> validate_required([:name, :amount, :recurrance, :target_date, :user_id])
    |> validate_number(:amount, greater_than_or_equal_to: 0)
    |> validate_inclusion(:recurrance, [:daily, :weekly, :monthly, :yearly])
    |> validate_initial_date()
    |> assoc_constraint(:user)
  end

  defp validate_initial_date(changeset) do
    case get_field(changeset, :recurrance) do
      :never -> validate_required(changeset, :initial_date)
      _ -> changeset
    end
  end
end
