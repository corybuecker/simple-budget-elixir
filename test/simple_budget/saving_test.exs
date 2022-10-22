defmodule SimpleBudget.SavingTest do
  use ExUnit.Case, async: true
  alias SimpleBudget.{Saving, User, Repo}

  setup _context do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
    %{user: %User{email: "test@example.com"} |> Repo.insert!()}
  end

  test "processes a changeset", context do
    saving =
      %Saving{name: "test", user: context.user, amount: 22}
      |> Saving.changeset()
      |> Repo.insert!()

    assert({:ok, _changeset} = Saving.changeset(saving, %{amount: 23}) |> Repo.update())
  end
end
