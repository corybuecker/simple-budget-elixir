defmodule SimpleBudgetWeb.DashboardHTML do
  use SimpleBudgetWeb, :html

  embed_templates "dashboard_html/*"

  def number_format(number, places \\ 2) do
    "$#{number |> Decimal.round(places)}"
  end
end
