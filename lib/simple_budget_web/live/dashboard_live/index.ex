defmodule SimpleBudgetWeb.DashboardLive.Index do
  use SimpleBudgetWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket |> assign(:page_title, "Dashboard")}
  end

  def render(assigns) do
    ~H"""
    <div>test</div>
    """
  end
end
