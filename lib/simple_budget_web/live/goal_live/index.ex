defmodule SimpleBudgetWeb.GoalLive.Index do
  use SimpleBudgetWeb, :live_view
  alias SimpleBudget.{Goals}
  require Logger

  def mount(_params, session, socket) do
    {:ok,
     socket
     |> assign(%{page_title: "Goals | Simple Budget"})
     |> assign(%{goals: Goals.all(session), identity: session["identity"]})}
  end

  def handle_event("delete", params, socket) do
    Goals.delete(socket.assigns, params)

    {:noreply, socket |> assign(:accounts, Goals.all(socket.assigns))}
  end
end
