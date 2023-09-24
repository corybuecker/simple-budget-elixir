defmodule SimpleBudget.Utilities.FakeDateTime do
  use Agent

  @spec start_link(String.t()) :: Agent.on_start()
  def start_link(initial_date) do
    Agent.start_link(fn -> initial_date |> DateTime.from_iso8601() end, name: FakeDateTime)
  end

  @spec set_today(String.t()) :: :ok
  def set_today(datetime) do
    Agent.update(FakeDateTime, fn _state -> datetime |> DateTime.from_iso8601() end)
  end

  @spec today :: DateTime.t()
  def today do
    Agent.get(FakeDateTime, fn {:ok, datetime, 0} -> datetime end)
  end

  @spec tomorrow :: DateTime.t()
  def tomorrow do
    Agent.get(FakeDateTime, fn {:ok, datetime, 0} -> datetime |> DateTime.add(1, :day) end)
  end
end
