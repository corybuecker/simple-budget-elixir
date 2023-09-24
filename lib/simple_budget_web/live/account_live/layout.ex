defmodule SimpleBudgetWeb.Accounts.Layout do
  use SimpleBudgetWeb, :live_component

  attr(:accounts, :list, required: true)
  attr(:preferences, SimpleBudget.User.Preferences, required: true)

  def render(assigns) do
    case assigns.preferences.layout do
      :list -> list_view(assigns)
      :grid -> grid_view(assigns)
    end
  end

  defp list_view(assigns) do
    ~H"""
    <div phx-update="stream" id="accounts-layout" class="flex">
      <%= for {id, account} <- @accounts do %>
        <div id={id}>
          <div><%= account.name %> &nbsp;&mdash;&nbsp; <%= account.balance %></div>
          <div>
            <.link navigate={"/accounts/#{account.id}"}>Edit</.link>

            <.custom_button data-confirm="Sure?" phx-click="delete" phx-value-id={account.id}>
              sDelete
            </.custom_button>
          </div>
        </div>
      <% end %>
    </div>
    """
  end

  defp grid_view(assigns) do
    ~H"""
    <div phx-update="stream" id="accounts-layout" class="flex flex-col gap-2">
      <%= for {id, account} <- @accounts do %>
        <div id={id}>
          <%= account.name %> &nbsp;&mdash;&nbsp; <%= account.balance %>
          <.link navigate={"/accounts/#{account.id}"}>Edit</.link>
          <.custom_button data-confirm="Sure?" phx-click="delete" phx-value-id={account.id}>
            Delete
          </.custom_button>
        </div>
      <% end %>
    </div>
    """
  end
end
