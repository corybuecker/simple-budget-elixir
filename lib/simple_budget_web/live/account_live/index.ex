defmodule SimpleBudgetWeb.AccountLive.Index do
  use SimpleBudgetWeb, :live_view
  require Logger

  def mount(_params, session, socket) do
    {:ok,
     socket
     |> assign(%{page_title: "Accounts"})
     |> assign(%{accounts: SimpleBudget.Accounts.all(session), identity: session["identity"]})}
  end

  def handle_event("delete", params, socket) do
    SimpleBudget.Accounts.delete(socket.assigns, params)

    {:noreply, socket |> assign(:accounts, SimpleBudget.Accounts.all(socket.assigns))}
  end
end
