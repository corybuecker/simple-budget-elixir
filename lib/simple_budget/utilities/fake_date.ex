defmodule SimpleBudget.Utilities.FakeDate do
  use Agent

  def start_link() do
    Agent.start_link(fn -> "2020-01-15" |> Date.from_iso8601!() end,
      name: SimpleBudget.Utilities.FakeDate
    )
  end

  def today() do
    Agent.get(SimpleBudget.Utilities.FakeDate, fn val -> val end)
  end

  def set(value) do
    Agent.update(SimpleBudget.Utilities.FakeDate, fn _val -> value |> Date.from_iso8601!() end)
  end
end
