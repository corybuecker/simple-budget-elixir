defmodule SimpleBudget.Utilities.Date do
  def today() do
    Date.utc_today()
  end

  def tomorrow() do
    Date.utc_today() |> Date.add(1)
  end
end
