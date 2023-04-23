defmodule SimpleBudget.SavingsTest do
  use ExUnit.Case, async: true
  alias SimpleBudget.{User, Repo, Savings, Saving}

  setup _context do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)

    with identity <- Ecto.UUID.generate() do
      %{
        identity: identity,
        user: %User{email: "test@example.com", identity: identity} |> Repo.insert!()
      }
    end
  end

  test "getting a new saving by user's identity", %{identity: identity} do
    assert(%Saving{id: nil} = Savings.get(%{"identity" => identity}, %{}))
  end
end
