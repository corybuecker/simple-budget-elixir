defmodule SimpleBudget.GoalConversionServer do
  alias SimpleBudget.{Goal, Repo, Saving}
  use GenServer
  require Logger
  # Callbacks
  def start_link(_) do
    GenServer.start_link(SimpleBudget.GoalConversionServer, [])
  end

  @impl true
  def init(_) do
    schedule()
    {:ok, []}
  end

  @impl true
  def handle_info(:work, state) do
    schedule()
    {:noreply, state}
  end

  def schedule do
    expired_goals = SimpleBudget.PrivateGoals.expired()
    Logger.info(expired_goals |> inspect())

    expired_goals
    |> Enum.map(fn goal ->
      %Saving{
        name: goal.name,
        amount: Goal.amortized_amount(goal),
        user_id: goal.user_id
      }
      |> Saving.changeset()
      |> Repo.insert!()

      goal
    end)
    |> Enum.each(fn goal ->
      goal |> Goal.changeset(%{target_date: Goal.next_target_date(goal)}) |> Repo.update!()
    end)

    Process.send_after(self(), :work, :timer.minutes(5))
  end
end
