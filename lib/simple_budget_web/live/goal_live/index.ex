defmodule SimpleBudgetWeb.GoalLive.Index do
  use SimpleBudgetWeb, :live_view
  alias SimpleBudget.Goals
  require Logger

  def mount(_params, session, socket) do
    user = SimpleBudget.Users.get_by_identity(session["identity"])
    goals = Goals.all(user)

    {:ok,
     socket
     |> assign(%{page_title: "Goals"})
     |> assign(%{identity: session["identity"]})
     |> assign(%{total_daily_amortized: Goals.total_daily_amortized(goals) |> Decimal.round(2)})
     |> assign(%{preferences_layout: user.preferences.layout})
     |> stream(:goals, goals)}
  end

  def handle_event("delete", params, socket) do
    deleted_goal = Goals.delete(socket.assigns, params)
    goals = Goals.all(socket.assigns)

    {:noreply,
     socket
     |> assign(:goals, Goals.all(socket.assigns))
     |> assign(:total_daily_amortized, Goals.total_daily_amortized(goals) |> Decimal.round(2))
     |> stream_delete(:goals, deleted_goal)}
  end

  def handle_event("update_preferences", %{"layout" => value}, socket) do
    Logger.debug(value)

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
