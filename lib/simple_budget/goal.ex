defmodule SimpleBudget.Goal do
  alias SimpleBudget.{Goal}
  use Ecto.Schema
  import Ecto.Changeset

  schema "goals" do
    field :name, :string
    field :amount, :decimal
    field :recurrance, Ecto.Enum, values: [:weekly, :daily, :monthly, :quarterly, :yearly, :never]
    field :target_date, :date

    belongs_to :user, SimpleBudget.User

    timestamps()
  end

  def changeset(goal, params \\ %{}) do
    goal
    |> cast(params, [:name, :amount, :recurrance, :target_date])
    |> validate_required([:name, :amount, :recurrance, :target_date, :user_id])
  end

  def amortized_amount(%SimpleBudget.Goal{recurrance: :never} = goal) do
    diff = Date.diff(goal.target_date, Date.utc_today())
    start_diff = -Date.diff(goal.inserted_at, Date.utc_today())

    Decimal.max(
      0,
      Decimal.mult(Decimal.div(goal.amount, Decimal.new(diff + 1)), Decimal.new(start_diff))
    )
  end

  def amortized_amount(%SimpleBudget.Goal{} = goal) do
    start = Date.add(goal.target_date, -duration_days(goal))
    start_diff = Date.diff(Date.utc_today(), start)

    Decimal.min(
      Decimal.max(
        0,
        Decimal.mult(
          Decimal.div(goal.amount, Decimal.new(duration_days(goal))),
          Decimal.new(start_diff)
        )
      ),
      goal.amount
    )
  end

  def next_target_date(%SimpleBudget.Goal{recurrance: :never} = goal) do
    goal.target_date
  end

  def next_target_date(%SimpleBudget.Goal{} = goal) do
    Date.add(goal.target_date, duration_days(goal))
  end

  defp duration_days(%Goal{recurrance: recurrance}) do
    case recurrance do
      :daily -> 1
      :weekly -> 7
      :monthly -> 30
      :quarterly -> 90
      :yearly -> 365
    end
  end
end
