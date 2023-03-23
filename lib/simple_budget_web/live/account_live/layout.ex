defmodule SimpleBudgetWeb.Accounts.Layout do
  use SimpleBudgetWeb, :live_component

  attr(:accounts, :list, required: true)
  attr(:accounts_layout, :atom, required: true)

  def render(assigns) do
    case assigns.accounts_layout do
      :list -> accounts_list(assigns)
      :grid -> grid(assigns)
    end
  end

  defp grid(assigns) do
    ~H"""
    <div phx-update="stream" id="accounts-layout" class="flex flex-wrap gap-2">
      <%= for {id, account} <- @accounts do %>
        <div class="flex flex-col border rounded" id={id} }>
          <div><%= account.name %> &nbsp;&mdash;&nbsp; <%= account.balance %></div>
          <div>
            <.link navigate={"/accounts/#{account.id}"}>Edit</.link>

            <.button phx-click="delete" phx-value-id={account.id}>
              sDelete
            </.button>
          </div>
        </div>
      <% end %>
    </div>
    """
  end

  defp accounts_list(assigns) do
    ~H"""
    <div phx-update="stream" id="accounts-layout" class="flex flex-col gap-2">
      <%= for {id, account} <- @accounts do %>
        <div id={id}>
          <%= account.name %> &nbsp;&mdash;&nbsp; <%= account.balance %>
          <.link navigate={"/accounts/#{account.id}"}>Edit</.link>
          <button phx-click="delete" phx-value-id={account.id}>
            Delete
          </button>
        </div>
      <% end %>
    </div>
    """
  end
end
