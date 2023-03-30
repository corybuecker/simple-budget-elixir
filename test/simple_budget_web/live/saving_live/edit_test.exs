defmodule SimpleBudgetWeb.SavingLive.EditTest do
  use SimpleBudgetWeb.ConnCase, async: true
  alias SimpleBudget.{User, Saving, Repo}

  setup %{conn: conn} do
    uuid = Ecto.UUID.generate()
    user = %User{email: "test@example.com", identity: uuid} |> Repo.insert!()

    %Saving{
      user: user,
      name: "This is a saving!",
      amount: 100
    }
    |> Repo.insert!()

    %{
      conn: conn |> Plug.Test.init_test_session(%{identity: uuid}),
      identity: uuid
    }
  end

  test "settings values on mount", %{conn: conn, identity: identity} do
    savings = SimpleBudget.Savings.all(%{"identity" => identity})
    conn = get(conn, "/savings/#{List.first(savings).id}")
    {:ok, _view, html} = live(conn)
    assert(String.contains?(html, "This is a saving!"))
  end

  test "validate", %{conn: conn, identity: identity} do
    savings = SimpleBudget.Savings.all(%{"identity" => identity})
    conn = get(conn, "/savings/#{List.first(savings).id}")
    {:ok, view, _html} = live(conn)
    results = view |> form("form") |> render_change(%{saving: %{"name" => "test1235"}})
    assert(String.contains?(results, "test1235"))
  end

  test "valid save", %{conn: conn, identity: identity} do
    savings = SimpleBudget.Savings.all(%{"identity" => identity})
    conn = get(conn, "/savings/#{List.first(savings).id}")
    {:ok, view, _html} = live(conn)

    {:error, {:live_redirect, %{kind: :push, to: "/savings"}}} =
      view |> form("form") |> render_submit(%{saving: %{"name" => "test1235"}})
  end

  test "invalid save", %{conn: conn, identity: identity} do
    savings = SimpleBudget.Savings.all(%{"identity" => identity})
    conn = get(conn, "/savings/#{List.first(savings).id}")
    {:ok, view, _html} = live(conn)

    results = view |> form("form") |> render_submit(%{saving: %{"name" => ""}})
    assert(String.contains?(results, "can&#39;t be blank"))
  end
end
