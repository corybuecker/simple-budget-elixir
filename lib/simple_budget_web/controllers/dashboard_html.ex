defmodule SimpleBudgetWeb.DashboardHTML do
  use SimpleBudgetWeb, :html

  embed_templates "dashboard_html/*"

  def number_format(number) do
    number
  end
end
