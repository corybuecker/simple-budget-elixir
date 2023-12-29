defmodule SimpleBudget.GoalTest do
  use SimpleBudget.DataCase

  setup do
    user =
      %SimpleBudget.User{email: "test@example.com", identity: Ecto.UUID.generate()}
      |> SimpleBudget.Repo.insert!()

    [user: user]
  end

  test "cannot change user", context do
    goal =
      %SimpleBudget.Goal{
        user_id: context.user.id,
        name: "test",
        amount: 100,
        recurrance: :monthly,
        initial_date: Date.utc_today(),
        target_date: Date.utc_today()
      }
      |> SimpleBudget.Repo.insert!()

    new_user =
      %SimpleBudget.User{email: "test2@example.com", identity: Ecto.UUID.generate()}
      |> SimpleBudget.Repo.insert!()

    goal =
      goal
      |> SimpleBudget.Goal.changeset(%{user_id: new_user.id, amount: 200})
      |> SimpleBudget.Repo.update!()

    assert(goal.user_id == context.user.id)
    assert(goal.amount == Decimal.new(200))
  end

  test "validates that the initial date is required when the recurrance is never", context do
    goal =
      %SimpleBudget.Goal{
        user_id: context.user.id,
        name: "test",
        amount: 100,
        recurrance: :never,
        initial_date: nil,
        target_date: Date.utc_today()
      }
      |> SimpleBudget.Goal.changeset(%{initial_date: nil})

    refute(goal.valid?)
  end

  test "validates that the initial date is optional when the recurrance is not never", context do
    goal =
      %SimpleBudget.Goal{
        user_id: context.user.id,
        name: "test",
        amount: 100,
        recurrance: :monthly,
        initial_date: nil,
        target_date: Date.utc_today()
      }
      |> SimpleBudget.Goal.changeset(%{initial_date: nil})

    assert(goal.valid?)
  end
end
