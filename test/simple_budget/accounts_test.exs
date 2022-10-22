defmodule SimpleBudget.AccountsTest do
  use ExUnit.Case, async: true
  alias SimpleBudget.{User, Account, Accounts, Repo}
  require Logger

  setup _context do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
    %{user: %User{email: "test@example.com", identity: Ecto.UUID.generate()} |> Repo.insert!()}
  end

  test "#all", context do
    account = %Account{user: context.user, name: "test", balance: 1} |> Repo.insert!()
    accounts = Accounts.all(%{"identity" => context.user.identity})

    assert(accounts |> length() == 1)
    assert(accounts |> Enum.map(fn v -> v.id end) == [account.id])
  end

  test "all by symbol", context do
    account = %Account{user: context.user, name: "test", balance: 1} |> Repo.insert!()
    accounts = Accounts.all(%{identity: context.user.identity})

    assert(accounts |> length() == 1)
    assert(accounts |> Enum.map(fn v -> v.id end) == [account.id])
  end

  test "#delete", context do
    %Account{id: id} = %Account{user: context.user, name: "test", balance: 1} |> Repo.insert!()
    t = Accounts.delete(%{identity: context.user.identity}, %{"id" => id |> Integer.to_string()})
    assert(t)
  end

  test "#get", context do
    t = Accounts.get(%{"identity" => context.user.identity}, %{})
    assert(t.user_id == context.user.id)
    assert(t.id == nil)
  end

  test "create", context do
    assert(Accounts.all(%{"identity" => context.user.identity}) == [])

    account =
      %Account{id: nil, user_id: context.user.id}
      |> Account.changeset(%{name: "test", balance: 1, debt: false})
      |> Accounts.save()

    assert(Accounts.all(%{"identity" => context.user.identity}) == [account])
  end

  test "upsert", context do
    account =
      %Account{id: nil, user_id: context.user.id}
      |> Account.changeset(%{name: "test", balance: 1, debt: false})
      |> Accounts.save()

    assert(Accounts.all(%{"identity" => context.user.identity}) == [account])

    account = account |> Account.changeset() |> Accounts.save()

    assert(Accounts.all(%{"identity" => context.user.identity}) == [account])
  end
end
