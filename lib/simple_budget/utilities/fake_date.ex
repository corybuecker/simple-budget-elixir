defmodule SimpleBudget.Utilities.FakeDate do
  use Agent

  @spec start_link(String.t()) :: Agent.on_start()
  def start_link(intial_date) do
    Agent.start_link(fn -> intial_date |> Date.from_iso8601!() end,
      name: SimpleBudget.Utilities.FakeDate
    )
  end

  @spec set_today(String.t()) :: :ok
  def set_today(date) do
    Agent.update(SimpleBudget.Utilities.FakeDate, fn _state -> date |> Date.from_iso8601!() end)
  end

  @spec today :: Date.t()
  def today do
    Agent.get(SimpleBudget.Utilities.FakeDate, fn val -> val end)
  end

  @spec tomorrow :: Date.t()
  def tomorrow do
    Agent.get(SimpleBudget.Utilities.FakeDate, fn val -> val |> Date.add(1) end)
  end
end
