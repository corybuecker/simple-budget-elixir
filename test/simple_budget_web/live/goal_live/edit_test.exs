defmodule SimpleBudgetWeb.GoalLive.EditTest do
  use SimpleBudgetWeb.ConnCase, async: true
  alias SimpleBudget.{User, Goal, Repo}

  setup %{conn: conn} do
    uuid = Ecto.UUID.generate()
    user = %User{email: "test@example.com", identity: uuid} |> Repo.insert!()

    %Goal{
      user: user,
      name: "This is a goal!",
      amount: 100,
      target_date: Date.from_iso8601!("2022-01-01")
    }
    |> Repo.insert!()

    %{
      conn: conn |> Plug.Test.init_test_session(%{identity: uuid}),
      identity: uuid
    }
  end

  test "settings values on mount", %{conn: conn, identity: identity} do
    goals = SimpleBudget.Goals.all(%{"identity" => identity})
    conn = get(conn, "/goals/#{List.first(goals).id}")
    {:ok, _view, html} = live(conn)
    assert(String.contains?(html, "This is a goal!"))
  end

  test "validate", %{conn: conn, identity: identity} do
    goals = SimpleBudget.Goals.all(%{"identity" => identity})
    conn = get(conn, "/goals/#{List.first(goals).id}")
    {:ok, view, _html} = live(conn)
    results = view |> form("form") |> render_change(%{goal: %{"name" => "test1235"}})
    assert(String.contains?(results, "test1235"))
  end

  test "valid save", %{conn: conn, identity: identity} do
    goals = SimpleBudget.Goals.all(%{"identity" => identity})
    conn = get(conn, "/goals/#{List.first(goals).id}")
    {:ok, view, _html} = live(conn)

    {:error, {:live_redirect, %{kind: :push, to: "/goals"}}} =
      view |> form("form") |> render_submit(%{goal: %{"name" => "test1235"}})
  end

  test "invalid save", %{conn: conn, identity: identity} do
    goals = SimpleBudget.Goals.all(%{"identity" => identity})
    conn = get(conn, "/goals/#{List.first(goals).id}")
    {:ok, view, _html} = live(conn)

    results = view |> form("form") |> render_submit(%{goal: %{"name" => ""}})
    assert(String.contains?(results, "can&#39;t be blank"))
  end
end
