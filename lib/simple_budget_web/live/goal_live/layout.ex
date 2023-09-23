defmodule SimpleBudgetWeb.Goals.Layout do
  use SimpleBudgetWeb, :live_component

  attr(:goals, :list, required: true)
  attr(:goals_layout, :atom, required: true)

  def render(assigns) do
    case assigns.goals_layout do
      :list -> goals_list(assigns)
      :grid -> grid(assigns)
    end
  end

  defp grid(assigns) do
    ~H"""
    <div phx-update="stream" id="goals-layout" class="flex flex-wrap gap-2">
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
            <.button phx-click="delete" phx-value-id={goal.id}>
              Delete
            </.button>
          </div>
        </div>
      <% end %>
    </div>
    """
  end

  defp goals_list(assigns) do
    ~H"""
    <div phx-update="stream" id="goal-layout" class="flex flex-col gap-2">
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
            <.button phx-click="delete" phx-value-id={goal.id}>
              Delete
            </.button>
          </div>
        </div>
      <% end %>
    </div>
    """
  end
end
