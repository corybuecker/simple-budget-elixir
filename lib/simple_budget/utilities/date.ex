defmodule SimpleBudget.Utilities.Date do
  @spec today :: Date.t()
  def today do
    Date.utc_today()
  end

  @spec tomorrow :: Date.t()
  def tomorrow do
    Date.utc_today() |> Date.add(1)
  end
end
