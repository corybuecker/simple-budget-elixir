defmodule SimpleBudgetWeb.LayoutToggle do
  use SimpleBudgetWeb, :live_component
  require Logger

  def update(assigns, socket) do
    Logger.info(assigns)
    {:ok, socket |> assign(assigns)}
  end

  @spec render(any) :: Phoenix.LiveView.Rendered.t()
  def render(assigns) do
    ~H"""
    <div class="flex gap-2">
      <div phx-click="update_preferences" phx-value-layout="grid">Grid</div>
      <div phx-click="update_preferences" phx-value-layout="list">List</div>
    </div>
    """
  end
end
