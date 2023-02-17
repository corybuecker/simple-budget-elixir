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

  def handle_event("update_preferences", %{"layout" => value}, socket) do
    with {:ok, identity} <- socket.assigns() |> Map.fetch(:identity),
         user <- SimpleBudget.Users.get_by_identity(identity) do
      SimpleBudget.Users.update(user, %{
        "preferences" => %{"layout" => value}
      })
    else
      anything ->
        Logger.error(anything)
    end

    {:noreply, socket}
  end
end
