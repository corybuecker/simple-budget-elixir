defmodule SimpleBudgetWeb.Savings.Layout do
  use SimpleBudgetWeb, :live_component

  attr(:savings, :list, required: true)
  attr(:preferences, SimpleBudget.User.Preferences, required: true)

  def render(assigns) do
    case assigns.preferences.layout do
      :list -> list_view(assigns)
      :grid -> grid_view(assigns)
    end
  end

  defp grid_view(assigns) do
    ~H"""
    <div phx-update="stream" id="savings-layout" class="flex gap-2">
      <%= for {id, saving} <- @savings do %>
        <div id={id}>
          <%= saving.name %> &nbsp;&mdash;&nbsp; <%= saving.amount %>
          <.link navigate={"/savings/#{saving.id}"}>Edit</.link>

          <.custom_button data-confirm="Sure?" phx-click="delete" phx-value-id={saving.id}>
            Delete
          </.custom_button>
        </div>
      <% end %>
    </div>
    """
  end

  defp list_view(assigns) do
    ~H"""
    <div phx-update="stream" id="saving-layout" class="flex flex-col">
      <%= for {id, saving} <- @savings do %>
        <div id={id}>
          <%= saving.name %> &nbsp;&mdash;&nbsp; <%= saving.amount %>
          <.link navigate={"/savings/#{saving.id}"}>Edit</.link>

          <.custom_button data-confirm="Sure?" phx-click="delete" phx-value-id={saving.id}>
            Delete
          </.custom_button>
        </div>
      <% end %>
    </div>
    """
  end
end
