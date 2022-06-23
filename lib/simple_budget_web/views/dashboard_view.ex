defmodule SimpleBudgetWeb.DashboardView do
  use SimpleBudgetWeb, :view

  @spec number_format(Decimal.t()) :: binary
  def number_format(number) do
    Number.Currency.number_to_currency(number)
  end
end
