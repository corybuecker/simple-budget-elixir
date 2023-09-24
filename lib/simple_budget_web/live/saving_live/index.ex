defmodule SimpleBudgetWeb.SavingLive.Index do
  use SimpleBudgetWeb, :live_view
  require Logger
  alias SimpleBudget.{Savings, Users}

  def mount(_params, session, socket) do
    user = SimpleBudget.Users.get_by_identity(session["identity"])

    {:ok,
     socket
     |> assign(%{page_title: "Savings"})
     |> assign(%{identity: session["identity"]})
     |> assign(%{preferences_layout: user.preferences.layout})
     |> stream(:savings, Savings.all(session), identity: session["identity"])}
  end

  def handle_event("delete", params, socket) do
    deleted_saving = Savings.delete(socket.assigns, params)

    {:noreply, socket |> stream_delete(:savings, deleted_saving)}
  end

  def handle_event("update_preferences", %{"layout" => value}, socket) do
    with {:ok, identity} <- socket.assigns() |> Map.fetch(:identity),
         user <- Users.get_by_identity(identity) do
      Users.update(user, %{
        "preferences" => %{"layout" => value}
      })
    else
      anything ->
        Logger.error(anything)
    end

    {:noreply, socket}
  end
end
