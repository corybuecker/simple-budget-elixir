defmodule SimpleBudgetWeb.SavingLive.IndexTest do
  use SimpleBudgetWeb.ConnCase, async: true
  require Logger
  alias SimpleBudget.{User, Saving, Repo}
  import Phoenix.LiveViewTest

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
      conn: conn |> Plug.Test.init_test_session(%{identity: uuid})
    }
  end

  test "settings values on mount", %{conn: conn} do
    conn = get(conn, "/savings")
    {:ok, _view, html} = live(conn)
    assert(String.contains?(html, "This is a saving!"))
  end

  test "delete", %{conn: conn} do
    conn = get(conn, "/savings")
    {:ok, view, html} = live(conn)
    assert(String.contains?(html, "This is a saving!"))

    results =
      view
      |> element("button", "Delete")
      |> render_click()

    refute(String.contains?(results, "This is a saving!"))
  end
end
