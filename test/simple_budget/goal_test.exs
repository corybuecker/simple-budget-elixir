defmodule SimpleBudget.GoalTest do
  use ExUnit.Case, async: true
  alias SimpleBudget.{Goal, User, Repo}

  setup _context do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
    %{user: %User{email: "test@example.com"} |> Repo.insert!()}
  end

  test "processes a changeset", context do
    goal =
      %Goal{
        name: "test",
        user: context.user,
        amount: 1,
        recurrance: :daily,
        target_date: Date.from_iso8601!("2020-01-01")
      }
      |> Goal.changeset(%{amount: 2})
      |> Repo.insert!()

    assert({:ok, _changeset} = Goal.changeset(goal) |> Repo.update())
  end

  test "amortized_amount for daily target tomorrow at midnight" do
    goal = %Goal{
      amount: 100,
      recurrance: :daily,
      target_date: Date.from_iso8601!("2020-01-16")
    }

    {:ok, expected} = Decimal.cast(49.99)

    assert_in_delta(
      expected |> Decimal.to_float(),
      Goal.amortized_amount(goal) |> Decimal.to_float(),
      0.01
    )
  end

  test "amortized_amount for weekly target tomorrow" do
    goal = %Goal{
      amount: 100,
      recurrance: :weekly,
      target_date: Date.from_iso8601!("2020-01-16")
    }

    {:ok, expected} = Decimal.cast(92.85)

    assert_in_delta(
      expected |> Decimal.to_float(),
      Goal.amortized_amount(goal) |> Decimal.to_float(),
      0.01
    )
  end

  test "amortized_amount for monthly target tomorrow" do
    goal = %Goal{
      amount: 100,
      recurrance: :monthly,
      target_date: Date.from_iso8601!("2020-01-16")
    }

    {:ok, expected} = Decimal.cast(98.33)

    assert_in_delta(
      expected |> Decimal.to_float(),
      Goal.amortized_amount(goal) |> Decimal.to_float(),
      0.01
    )
  end

  test "amortized_amount for quarterly target next month" do
    goal = %Goal{
      amount: 100,
      recurrance: :quarterly,
      target_date: Date.from_iso8601!("2020-02-16")
    }

    {:ok, expected} = Decimal.cast(65.0)

    assert_in_delta(
      expected |> Decimal.to_float(),
      Goal.amortized_amount(goal) |> Decimal.to_float(),
      0.01
    )
  end

  test "amortized_amount for yearly target next month" do
    goal = %Goal{
      amount: 100,
      recurrance: :yearly,
      target_date: Date.from_iso8601!("2020-02-16")
    }

    {:ok, expected} = Decimal.cast(91.369)

    assert_in_delta(
      expected |> Decimal.to_float(),
      Goal.amortized_amount(goal) |> Decimal.to_float(),
      0.01
    )
  end

  test "amortized_amount for never recurring target started yesterday and targeting tomorrow" do
    goal = %Goal{
      amount: 100,
      recurrance: :never,
      target_date: Date.from_iso8601!("2020-01-16"),
      inserted_at: Date.from_iso8601!("2020-01-14") |> DateTime.new!(~T[00:00:00])
    }

    {:ok, expected} = Decimal.cast(75.0)

    assert_in_delta(
      expected |> Decimal.to_float(),
      Goal.amortized_amount(goal) |> Decimal.to_float(),
      0.01
    )
  end

  test "amortized_amount for never recurring target started month ago and ending next month" do
    goal = %Goal{
      amount: 100,
      recurrance: :never,
      target_date: Date.from_iso8601!("2020-02-15"),
      inserted_at: Date.from_iso8601!("2019-12-15") |> DateTime.new!(~T[00:00:00])
    }

    {:ok, expected} = Decimal.cast(50.806)

    assert_in_delta(
      expected |> Decimal.to_float(),
      Goal.amortized_amount(goal) |> Decimal.to_float(),
      0.01
    )
  end

  test "amortized_amount for never recurring target started month ago and ending next week" do
    goal = %Goal{
      amount: 100,
      recurrance: :never,
      target_date: Date.from_iso8601!("2020-01-22"),
      inserted_at: Date.from_iso8601!("2019-12-15") |> DateTime.new!(~T[00:00:00])
    }

    {:ok, expected} = Decimal.cast(82.8947)

    assert_in_delta(
      expected |> Decimal.to_float(),
      Goal.amortized_amount(goal) |> Decimal.to_float(),
      0.01
    )
  end

  test "amortized_amount for never recurring target started month ago and ended yesterday" do
    goal = %Goal{
      amount: 100,
      recurrance: :never,
      target_date: Date.from_iso8601!("2020-01-14"),
      inserted_at: Date.from_iso8601!("2019-12-15") |> DateTime.new!(~T[00:00:00])
    }

    {:ok, expected} = Decimal.cast(100)

    assert_in_delta(
      expected |> Decimal.to_float(),
      Goal.amortized_amount(goal) |> Decimal.to_float(),
      0.01
    )
  end

  test "next target date for monthly" do
    goal = %Goal{
      amount: 100,
      recurrance: :monthly,
      target_date: Date.from_iso8601!("2020-01-16")
    }

    expectation = Date.from_iso8601!("2020-02-15")
    assert(^expectation = Goal.next_target_date(goal))
  end

  test "next target date for never" do
    goal = %Goal{
      amount: 100,
      recurrance: :never,
      target_date: Date.from_iso8601!("2020-01-16")
    }

    expectation = Date.from_iso8601!("2020-01-16")
    assert(^expectation = Goal.next_target_date(goal))
  end
end
