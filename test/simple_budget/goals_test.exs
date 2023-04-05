defmodule SimpleBudget.GoalsTest do
  use ExUnit.Case, async: true
  alias SimpleBudget.{User, Goal, Goals, Repo}

  setup _context do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
    %{user: %User{email: "test@example.com", identity: Ecto.UUID.generate()} |> Repo.insert!()}
  end

  test "#all", context do
    goal =
      %Goal{
        user: context.user,
        name: "test",
        recurrance: :monthly,
        amount: 10,
        target_date: Date.from_iso8601!("2020-02-15")
      }
      |> Repo.insert!()

    goals = Goals.all(%{"identity" => context.user.identity})

    assert(goals |> length() == 1)
    assert(goals |> Enum.map(fn v -> v.id end) == [goal.id])
  end

  test "all by symbol", context do
    goal =
      %Goal{
        user: context.user,
        name: "test",
        recurrance: :monthly,
        amount: 10,
        target_date: Date.from_iso8601!("2020-02-15")
      }
      |> Repo.insert!()

    goals = Goals.all(%{identity: context.user.identity})

    assert(goals |> length() == 1)
    assert(goals |> Enum.map(fn v -> v.id end) == [goal.id])
  end

  test "#delete", context do
    %Goal{id: id} =
      %Goal{
        user: context.user,
        name: "test",
        recurrance: :monthly,
        amount: 10,
        target_date: Date.from_iso8601!("2020-02-15")
      }
      |> Repo.insert!()

    t = Goals.delete(%{identity: context.user.identity}, %{"id" => id |> Integer.to_string()})
    assert(t)
  end

  test "#get", context do
    t = Goals.get(%{"identity" => context.user.identity}, %{})
    assert(t.user_id == context.user.id)
    assert(t.id == nil)
  end

  test "create", context do
    assert(Goals.all(%{"identity" => context.user.identity}) == [])

    goal =
      %Goal{id: nil, user_id: context.user.id}
      |> Goal.changeset(%{
        name: "test",
        recurrance: :monthly,
        amount: 10,
        target_date: Date.from_iso8601!("2020-02-15")
      })
      |> Goals.save()

    assert(Goals.all(%{"identity" => context.user.identity}) == [goal])
  end

  test "upsert", context do
    goal =
      %Goal{id: nil, user_id: context.user.id}
      |> Goal.changeset(%{
        name: "test",
        recurrance: :monthly,
        amount: 10,
        target_date: Date.from_iso8601!("2020-02-15")
      })
      |> Goals.save()

    assert(Goals.all(%{"identity" => context.user.identity}) == [goal])

    goal = goal |> Goal.changeset() |> Goals.save()

    assert(Goals.all(%{"identity" => context.user.identity}) == [goal])
  end

  test "spendable", context do
    %SimpleBudget.Account{
      id: nil,
      name: "test",
      user_id: context.user.id,
      balance: 100,
      debt: false
    }
    |> SimpleBudget.Account.changeset()
    |> SimpleBudget.Accounts.save()

    %Goal{id: nil, user_id: context.user.id}
    |> Goal.changeset(%{
      name: "test",
      recurrance: :monthly,
      amount: 50,
      target_date: Date.from_iso8601!("2020-01-31")
    })
    |> Goals.save()

    assert_in_delta(
      Decimal.to_float(Goals.spendable(%{"identity" => context.user.identity})),
      76.67,
      0.01
    )
  end

  test "spendable today", context do
    %SimpleBudget.Account{
      id: nil,
      name: "test",
      user_id: context.user.id,
      balance: 100,
      debt: false
    }
    |> SimpleBudget.Account.changeset()
    |> SimpleBudget.Accounts.save()

    %SimpleBudget.Account{
      id: nil,
      name: "test",
      user_id: context.user.id,
      balance: 10,
      debt: true
    }
    |> SimpleBudget.Account.changeset()
    |> SimpleBudget.Accounts.save()

    %SimpleBudget.Saving{
      id: nil,
      name: "test",
      user_id: context.user.id,
      amount: 1
    }
    |> SimpleBudget.Saving.changeset()
    |> SimpleBudget.Savings.save()

    %Goal{id: nil, user_id: context.user.id}
    |> Goal.changeset(%{
      name: "test",
      recurrance: :monthly,
      amount: 50,
      target_date: Date.from_iso8601!("2020-01-31")
    })
    |> Goals.save()

    assert_in_delta(
      Decimal.to_float(Goals.spendable_today(%{"identity" => context.user.identity})),
      4.10,
      0.01
    )
  end

  test "spendable today last day", %{user: %{id: id, identity: identity}} do
    %SimpleBudget.Account{
      name: "test",
      user_id: id,
      balance: 100,
      debt: false
    }
    |> SimpleBudget.Account.changeset()
    |> SimpleBudget.Accounts.save()

    SimpleBudget.Utilities.FakeDate.set_today("2020-01-31")

    assert_in_delta(
      Decimal.to_float(Goals.spendable_today(%{"identity" => identity})),
      3.57,
      0.01
    )

    SimpleBudget.Utilities.FakeDate.set_today("2020-01-15")
  end

  test "spendable today with total", context do
    %SimpleBudget.Account{
      id: nil,
      name: "test",
      user_id: context.user.id,
      balance: 100,
      debt: false
    }
    |> SimpleBudget.Account.changeset()
    |> SimpleBudget.Accounts.save()

    %Goal{id: nil, user_id: context.user.id}
    |> Goal.changeset(%{
      name: "test",
      recurrance: :monthly,
      amount: 50,
      target_date: Date.from_iso8601!("2020-01-31")
    })
    |> Goals.save()

    assert_in_delta(
      Decimal.to_float(
        Goals.spendable_today(%{"identity" => context.user.identity}, Decimal.new(500))
      ),
      31.25,
      0.01
    )
  end

  test "increment target date for a recurring goal", %{user: user} do
    goal =
      %Goal{
        user: user,
        name: "test",
        recurrance: :monthly,
        amount: 10,
        target_date: Date.from_iso8601!("2020-02-15")
      }
      |> Repo.insert!()

    goal = goal |> Goals.increment_target_date()

    assert(goal.target_date == Date.from_iso8601!("2020-03-16"))
  end

  test "increment target date for a non-recurring goal", %{user: user} do
    goal =
      %Goal{
        user: user,
        name: "test",
        recurrance: :never,
        amount: 10,
        target_date: Date.from_iso8601!("2020-02-15")
      }
      |> Repo.insert!()

    goal |> Goals.increment_target_date()

    assert(Enum.empty?(Goals.all(user)))
  end
end
