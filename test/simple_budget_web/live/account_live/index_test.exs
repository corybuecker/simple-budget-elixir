defmodule SimpleBudgetWeb.AccountLive.IndexTest do
  use SimpleBudgetWeb.ConnCase, async: true
  require Logger
  alias SimpleBudget.{User, Account, Repo}

  setup %{conn: conn} do
    uuid = Ecto.UUID.generate()
    user = %User{email: "test@example.com", identity: uuid} |> Repo.insert!()
    %Account{user: user, name: "test", balance: 100, debt: false} |> Repo.insert!()

    %{
      conn: conn |> Plug.Test.init_test_session(%{identity: uuid})
    }
  end

  test "settings values on mount", %{conn: conn} do
    conn = get(conn, "/accounts")
    {:ok, _view, html} = live(conn)
    assert(String.contains?(html, "test  —  100"))
  end

  test "delete", %{conn: conn} do
    conn = get(conn, "/accounts")
    {:ok, view, html} = live(conn)
    assert(String.contains?(html, "test  —  100"))

    results =
      view
      |> element("button", "Delete")
      |> render_click()

    refute(String.contains?(results, "test  —  100"))
  end
end
