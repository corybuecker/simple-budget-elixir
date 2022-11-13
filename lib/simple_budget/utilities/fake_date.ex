defmodule SimpleBudget.Utilities.FakeDate do
  use Agent

  @spec start_link :: {:ok, pid}
  def start_link() do
    {:ok, _pid} =
      Agent.start_link(fn -> "2020-01-15" |> Date.from_iso8601!() end,
        name: SimpleBudget.Utilities.FakeDate
      )
  end

  def today() do
    Agent.get(SimpleBudget.Utilities.FakeDate, fn val -> val end)
  end
end
