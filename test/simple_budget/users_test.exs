defmodule SimpleBudget.UsersTest do
  use ExUnit.Case, async: true
  alias SimpleBudget.{User, Users, Repo}
  alias Ecto.Adapters.SQL.Sandbox

  setup _context do
    :ok = Sandbox.checkout(Repo)
  end

  test "#existing_identity?" do
    uuid = Ecto.UUID.generate()
    %User{email: "test@example.com", identity: uuid} |> Repo.insert!()

    assert(Users.existing_identity?(uuid))
  end

  test "#get_by_email" do
    %User{email: "test@example.com"} |> Repo.insert!()

    assert(%User{email: "test@example.com"} = Users.get_by_email("test@example.com"))
  end

  test "#get_by_identity" do
    uuid = Ecto.UUID.generate()

    %User{email: "test@example.com", identity: uuid} |> Repo.insert!()

    assert(%User{email: "test@example.com"} = Users.get_by_identity(uuid))
  end
end
