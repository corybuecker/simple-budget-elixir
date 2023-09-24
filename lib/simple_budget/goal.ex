defmodule SimpleBudget.Goal do
  alias SimpleBudget.{Goal}

  import Ecto.Changeset
  require Logger
  use Ecto.Schema

  @type t :: %SimpleBudget.Goal{
          name: String.t(),
          amount: non_neg_integer(),
          recurrance: :weekly | :daily | :monthly | :quarterly | :yearly | :never
        }

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
    |> validate_required([:name, :amount, :recurrance, :target_date])
  end

  def daily_amortized_amount(%SimpleBudget.Goal{} = goal) do
    Decimal.div(goal.amount, Decimal.new(days_to_amortize_across(goal)))
  end

  @spec amortized_amount(Goal.t()) :: Decimal.t()
  def amortized_amount(%SimpleBudget.Goal{recurrance: :never} = goal) do
    seconds_to_amortize_across = seconds_to_amortize_across(goal)
    days_amortized = DateTime.diff(today(), goal.inserted_at)

    amortized_amount =
      Decimal.mult(
        Decimal.div(goal.amount, Decimal.new(seconds_to_amortize_across)),
        Decimal.new(days_amortized)
      )

    Decimal.min(
      Decimal.max(
        amortized_amount,
        0
      ),
      goal.amount
    )
  end

  def amortized_amount(%SimpleBudget.Goal{} = goal) do
    start =
      goal.target_date
      |> DateTime.new!(~T[00:00:00])
      |> DateTime.add(-seconds_to_amortize_across(goal))

    start_diff = DateTime.diff(today(), start)

    Decimal.min(
      Decimal.max(
        0,
        Decimal.mult(
          Decimal.div(goal.amount, Decimal.new(seconds_to_amortize_across(goal))),
          Decimal.new(start_diff)
        )
      ),
      goal.amount
    )
  end

  @spec next_target_date(Goal.t()) :: Date.t()
  def next_target_date(%SimpleBudget.Goal{recurrance: :never} = goal) do
    goal.target_date
  end

  def next_target_date(%SimpleBudget.Goal{} = goal) do
    Date.add(goal.target_date, days_to_amortize_across(goal))
  end

  defp seconds_to_amortize_across(%Goal{} = goal) do
    days_to_amortize_across(goal) * 86400
  end

  defp days_to_amortize_across(%Goal{
         recurrance: recurrance,
         target_date: target_date,
         inserted_at: inserted_at
       }) do
    case recurrance do
      :daily -> 1
      :weekly -> 7
      :monthly -> 30
      :quarterly -> 90
      :yearly -> 365
      :never -> Date.diff(target_date, inserted_at)
    end
  end

  defp today() do
    Application.get_env(:simple_budget, SimpleBudget.Goals)[:datetime_adapter].today()
  end
end
