defmodule SimpleBudgetWeb.DashboardViewTest do
  use SimpleBudgetWeb.ConnCase, async: true

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View

  test "it renders" do
    assert render_to_string(SimpleBudgetWeb.DashboardView, "show.html", total: 10, daily: 10) ==
             "$10.00\n<br>\n$10.00"
  end

  test "returns money" do
    assert SimpleBudgetWeb.DashboardView.number_format(10) == "$10.00"
  end
end
