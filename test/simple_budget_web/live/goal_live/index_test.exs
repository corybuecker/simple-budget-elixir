defmodule SimpleBudgetWeb.GoalLive.IndexTest do
  use SimpleBudgetWeb.ConnCase, async: true
  alias SimpleBudget.{User, Goal, Repo}

  setup %{conn: conn} do
    uuid = Ecto.UUID.generate()
    user = %User{email: "test@example.com", identity: uuid} |> Repo.insert!()

    %Goal{
      user: user,
      name: "This is a goal!",
      amount: 100,
      target_date: Date.from_iso8601!("2021-02-15")
    }
    |> Repo.insert!()

    %{
      conn: conn |> Plug.Test.init_test_session(%{identity: uuid})
    }
  end

  test "settings values on mount", %{conn: conn} do
    conn = get(conn, "/goals")
    {:ok, _view, html} = live(conn)
    assert(String.contains?(html, "This is a goal!"))
  end

  test "delete", %{conn: conn} do
    conn = get(conn, "/goals")
    {:ok, view, html} = live(conn)
    assert(String.contains?(html, "This is a goal!"))

    results =
      view
      |> element("button", "Delete")
      |> render_click()

    refute(String.contains?(results, "This is a goal!"))
  end
end
