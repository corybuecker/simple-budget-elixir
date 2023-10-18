defmodule SimpleBudgetWeb.GoalLive.Index do
  use SimpleBudgetWeb, :live_view
  alias SimpleBudget.Goals
  require Logger

  def mount(_params, session, socket) do
    user = SimpleBudget.Users.get_by_identity(session["identity"])
    goals = Goals.all(user)

    {:ok,
     socket
     |> assign(%{
       page_title: "Goals",
       identity: user.identity,
       preferences: user.preferences
     })
     |> stream(:goals, goals)}
  end

  def handle_event("delete", params, socket) do
    deleted_goal = Goals.delete(socket.assigns, params)
    goals = Goals.all(%{"identity" => socket.assigns.identity})

    {:noreply,
     socket
     |> assign(:goals, goals)
     |> stream_delete(:goals, deleted_goal)}
  end

  def handle_event("update_preferences", %{"layout" => value}, socket) do
    with {:ok, identity} <- socket.assigns() |> Map.fetch(:identity),
         user <- SimpleBudget.Users.get_by_identity(identity) do
      SimpleBudget.Users.update(user, %{
        "preferences" => %{"layout" => value}
      })

      user = SimpleBudget.Users.get_by_identity(identity)
      goals = Goals.all(user)

      {:noreply,
       socket |> assign(:preferences, user.preferences) |> stream(:goals, goals, reset: true)}
    else
      anything ->
        Logger.error(anything)
        {:noreply, socket}
    end
  end

  def render(assigns) do
    ~H"""
    <div class="flex">
      <.link class="p-1 border border-slate-400 rounded" navigate="/goals/new">New</.link>
    </div>
    <div>
      <.live_component
        id="goals"
        module={SimpleBudgetWeb.Goals.Layout}
        preferences={@preferences}
        goals={@streams.goals}
      />
    </div>
    """
  end
end
