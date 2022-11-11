defmodule SimpleBudgetWeb.SavingLive.Index do
  use SimpleBudgetWeb, :live_view
  require Logger

  def mount(_params, session, socket) do
    {:ok,
     socket
     |> assign(%{page_title: "Savings"})
     |> assign(%{savings: SimpleBudget.Savings.all(session), identity: session["identity"]})}
  end

  def handle_event("delete", params, socket) do
    SimpleBudget.Savings.delete(socket.assigns, params)

    {:noreply, socket |> assign(:savings, SimpleBudget.Savings.all(socket.assigns))}
  end
end
