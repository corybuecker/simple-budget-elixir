defmodule SimpleBudgetWeb.GoalLive.Index do
  use SimpleBudgetWeb, :live_view
  alias SimpleBudget.{Goals}
  require Logger

  def mount(_params, session, socket) do
    goals = Goals.all(session)

    {:ok,
     socket
     |> assign(%{page_title: "Goals"})
     |> assign(%{goals: goals, identity: session["identity"]})
     |> assign(%{total_daily_amortized: Goals.total_daily_amortized(goals) |> Decimal.round(2)})}
  end

  def handle_event("delete", params, socket) do
    Goals.delete(socket.assigns, params)
    goals = Goals.all(socket.assigns)

    {:noreply,
     socket
     |> assign(:goals, Goals.all(socket.assigns))
     |> assign(:total_daily_amortized, Goals.total_daily_amortized(goals) |> Decimal.round(2))}
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
