defmodule SimpleBudgetWeb.Savings.Layout do
  use SimpleBudgetWeb, :live_component

  attr(:savings, :list, required: true)
  attr(:savings_layout, :atom, required: true)

  def render(assigns) do
    case assigns.savings_layout do
      :list -> savings_list(assigns)
      :grid -> grid(assigns)
    end
  end

  defp grid(assigns) do
    ~H"""
    <div phx-update="stream" id="savings-layout" class="flex flex-wrap gap-2">
      <%= for {id, saving} <- @savings do %>
        <div id={id}>
          <%= saving.name %> &nbsp;&mdash;&nbsp; <%= saving.amount %>
          <.link navigate={"/savings/#{saving.id}"}>Edit</.link>

          <.button phx-click="delete" phx-value-id={saving.id}>
            Delete
          </.button>
        </div>
      <% end %>
    </div>
    """
  end

  defp savings_list(assigns) do
    ~H"""
    <div phx-update="stream" id="saving-layout" class="flex flex-col gap-2">
      <%= for {id, saving} <- @savings do %>
        <div id={id}>
          <%= saving.name %> &nbsp;&mdash;&nbsp; <%= saving.amount %>
          <.link navigate={"/savings/#{saving.id}"}>Edit</.link>

          <.button phx-click="delete" phx-value-id={saving.id}>
            Delete
          </.button>
        </div>
      <% end %>
    </div>
    """
  end
end
