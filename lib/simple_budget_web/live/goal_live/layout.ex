defmodule SimpleBudgetWeb.Goals.Layout do
  use SimpleBudgetWeb, :live_component

  attr(:goals, :list, required: true)
  attr(:preferences, SimpleBudget.User.Preferences, required: true)

  def render(assigns) do
    case assigns.preferences.layout do
      :list -> list_view(assigns)
      :grid -> grid_view(assigns)
    end
  end

  defp grid_view(assigns) do
    ~H"""
    <div phx-update="stream" id="goals-layout" class="flex">
      <%= for {id, goal} <- @goals do %>
        <div id={id}>
          <div>
            <%= goal.name %>
          </div>
          <div>$<%= goal.amount |> Decimal.round(2) %></div>
          <div><%= goal.target_date %></div>
          <div>
            $<%= SimpleBudget.Goal.daily_amortized_amount(goal) |> Decimal.round(2) %>
          </div>
          <div>
            $<%= SimpleBudget.Goal.amortized_amount(goal) |> Decimal.round(2) %>
          </div>
          <div class="text-center">
            <.link navigate={"/goals/#{goal.id}"}>Edit</.link>
            <.custom_button data-confirm="Sure?" phx-click="delete" phx-value-id={goal.id}>
              Delete
            </.custom_button>
          </div>
        </div>
      <% end %>
    </div>
    """
  end

  defp list_view(assigns) do
    ~H"""
    <div phx-update="stream" id="goals-layout" class="flex flex-col">
      <%= for {id, goal} <- @goals do %>
        <div class="flex gap-2" id={id}>
          <div class="basis-1/6">
            <%= goal.name %>
          </div>
          <div class="basis-1/6">$<%= goal.amount |> Decimal.round(2) %></div>
          <div class="basis-1/6"><%= goal.target_date %></div>
          <div class="basis-1/6">
            $<%= SimpleBudget.Goal.daily_amortized_amount(goal) |> Decimal.round(2) %>
          </div>
          <div class="basis-1/6">
            $<%= SimpleBudget.Goal.amortized_amount(goal) |> Decimal.round(2) %>
          </div>
          <div class="basis-1/6">
            <.link navigate={"/goals/#{goal.id}"}>Edit</.link>
            <.custom_button data-confirm="Sure?" phx-click="delete" phx-value-id={goal.id}>
              Delete
            </.custom_button>
          </div>
        </div>
      <% end %>
    </div>
    """
  end
end
