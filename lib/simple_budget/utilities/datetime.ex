defmodule SimpleBudget.Utilities.DateTime do
  @spec today :: DateTime.t()
  def today do
    DateTime.utc_now()
  end

  @spec tomorrow :: DateTime.t()
  def tomorrow do
    DateTime.utc_now() |> DateTime.add(1, :day)
  end
end
