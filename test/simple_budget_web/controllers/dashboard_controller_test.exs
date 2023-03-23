defmodule SimpleBudgetWeb.DashboardViewTest do
  use SimpleBudgetWeb.ConnCase, async: true

  test "it renders", %{conn: conn} do
    conn = get(conn, ~p"/")
    assert html_response(conn, 302)
  end
end
