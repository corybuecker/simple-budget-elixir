defmodule SimpleBudgetWeb.AccountLive.EditTest do
  use SimpleBudgetWeb.ConnCase, async: true
  require Logger
  alias SimpleBudget.{User, Account, Repo}

  setup %{conn: conn} do
    uuid = Ecto.UUID.generate()
    user = %User{email: "test@example.com", identity: uuid} |> Repo.insert!()

    %Account{
      user: user,
      name: "This is an account!",
      balance: 100
    }
    |> Repo.insert!()

    %{
      conn: conn |> Plug.Test.init_test_session(%{identity: uuid}),
      identity: uuid
    }
  end

  test "settings values on mount", %{conn: conn, identity: identity} do
    accounts = SimpleBudget.Accounts.all(%{"identity" => identity})
    conn = get(conn, "/accounts/#{List.first(accounts).id}")
    {:ok, _view, html} = live(conn)
    assert(String.contains?(html, "This is an account!"))
  end

  test "validate", %{conn: conn, identity: identity} do
    accounts = SimpleBudget.Accounts.all(%{"identity" => identity})
    conn = get(conn, "/accounts/#{List.first(accounts).id}")
    {:ok, view, _html} = live(conn)
    results = view |> form("form") |> render_change(%{account: %{"name" => "test1235"}})
    assert(String.contains?(results, "test1235"))
  end

  test "validate empty blanace", %{conn: conn, identity: identity} do
    accounts = SimpleBudget.Accounts.all(%{"identity" => identity})
    conn = get(conn, "/accounts/#{List.first(accounts).id}")
    {:ok, view, _html} = live(conn)
    results = view |> form("form") |> render_change(%{account: %{"balance" => ""}})
    assert(String.contains?(results, "balance: {&quot;can&#39;t be blank&quot;"))
  end

  test "validate debt", %{conn: conn, identity: identity} do
    accounts = SimpleBudget.Accounts.all(%{"identity" => identity})
    conn = get(conn, "/accounts/#{List.first(accounts).id}")
    {:ok, view, _html} = live(conn)
    results = view |> form("form") |> render_change(%{account: %{"debt" => "true"}})
    assert(String.contains?(results, "name=\"account[debt]\" type=\"checkbox\" value=\"true\""))
  end

  test "validate empty debt", %{conn: conn, identity: identity} do
    accounts = SimpleBudget.Accounts.all(%{"identity" => identity})
    conn = get(conn, "/accounts/#{List.first(accounts).id}")
    {:ok, view, _html} = live(conn)
    results = view |> form("form") |> render_change(%{account: %{"debt" => ""}})
    assert(String.contains?(results, "debt: {&quot;can&#39;t be blank&quot;"))
  end

  test "valid save", %{conn: conn, identity: identity} do
    accounts = SimpleBudget.Accounts.all(%{"identity" => identity})
    conn = get(conn, "/accounts/#{List.first(accounts).id}")
    {:ok, view, _html} = live(conn)

    {:error, {:live_redirect, %{kind: :push, to: "/accounts"}}} =
      view |> form("form") |> render_submit(%{account: %{"name" => "test1235"}})
  end

  test "invalid save", %{conn: conn, identity: identity} do
    accounts = SimpleBudget.Accounts.all(%{"identity" => identity})
    conn = get(conn, "/accounts/#{List.first(accounts).id}")
    {:ok, view, _html} = live(conn)

    results = view |> form("form") |> render_submit(%{account: %{"name" => ""}})
    assert(String.contains?(results, "can&#39;t be blank"))
  end
end
