defmodule SimpleBudget.AccountTest do
  use ExUnit.Case, async: true
  alias SimpleBudget.{Account, User, Repo}

  setup _context do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
    %{user: %User{email: "test@example.com"} |> Repo.insert!()}
  end

  test "processes a changeset", context do
    account =
      %Account{name: "test", user: context.user, balance: 1, debt: false} |> Repo.insert!()

    assert({:ok, _changeset} = Account.changeset(account, %{debt: true}) |> Repo.update())
  end
end
