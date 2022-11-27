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

  test "amortized_amount for daily target tomorrow" do
    goal = %Goal{
      amount: 100,
      recurrance: :daily,
      target_date: Date.from_iso8601!("2020-01-16")
    }

    {:ok, expected} = Decimal.cast(0)
    assert(^expected = Goal.amortized_amount(goal))
  end

  test "amortized_amount for weekly target tomorrow" do
    goal = %Goal{
      amount: 100,
      recurrance: :weekly,
      target_date: Date.from_iso8601!("2020-01-16")
    }

    {:ok, expected} = Decimal.cast(85.71428)

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

    {:ok, expected} = Decimal.cast(96.66667)

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

    {:ok, expected} = Decimal.cast(64.444)

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

    {:ok, expected} = Decimal.cast(91.2328)

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
      inserted_at: Date.from_iso8601!("2020-01-14")
    }

    {:ok, expected} = Decimal.cast(50)

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
      target_date: Date.from_iso8601!("2019-12-15"),
      inserted_at: Date.from_iso8601!("2020-02-15")
    }

    {:ok, expected} = Decimal.cast(50)

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
      inserted_at: Date.from_iso8601!("2019-12-15")
    }

    {:ok, expected} = Decimal.cast(81.57)

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
      inserted_at: Date.from_iso8601!("2019-12-15")
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
