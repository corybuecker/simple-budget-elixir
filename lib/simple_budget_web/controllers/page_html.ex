defmodule SimpleBudgetWeb.PageHTML do
  use SimpleBudgetWeb, :html

  attr :spendable_today, Decimal, required: true
  attr :spendable_total, Decimal, required: true
  attr :days_left, :integer, required: true
  attr :total_daily_amortized, Decimal, required: true

  def home(assigns) do
    ~H"""
    <p>Spendable today -> <%= assigns.spendable_today %></p>
    <p>Total -> <%= assigns.spendable_total %></p>
    <p>Days remaining -> <%= assigns.days_left %></p>
    <p>Total daily amortized -> <%= assigns.total_daily_amortized %></p>
    """
  end
end
