defmodule SimpleBudget.UserTest do
  use ExUnit.Case, async: true
  alias SimpleBudget.{User, Repo}

  setup _context do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
  end

  test "processes a changeset" do
    user = %User{email: "test@example.com"} |> Repo.insert!()

    assert(
      {:ok, _changeset} = User.changeset(user, %{email: "test2@example.com"}) |> Repo.update()
    )
  end

  test "processes an empty changeset" do
    user = %User{email: "test@example.com"} |> Repo.insert!()

    assert({:ok, _changeset} = User.changeset(user) |> Repo.update())
  end
end
