defmodule SimpleBudget.UserTest do
  use ExUnit.Case, async: true
  alias SimpleBudget.{User, Repo}

  setup _context do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
  end

  test "processes a changeset" do
    user =
      %User{email: "test@example.com", preferences: %{layout: :automatic}}
      |> Repo.insert!()

    assert(
      {:ok, _changeset} =
        User.changeset(user, %{email: "test2@example.com", preferences: %{layout: :grid}})
        |> Repo.update()
    )
  end

  test "processes an empty changeset" do
    user = %User{email: "test@example.com"} |> Repo.insert!()

    assert({:ok, _changeset} = User.changeset(user) |> Repo.update())
  end

  test "changing a layout to nil sets it to automatic (effectively unsetting)" do
    user =
      %User{email: "test@example.com", preferences: %{layout: :grid}}
      |> Repo.insert!()

    assert({:ok, user} = User.changeset(user, %{preferences: %{layout: nil}}) |> Repo.update())

    assert(user.preferences.layout == :automatic)
  end
end
