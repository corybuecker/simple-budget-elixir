defmodule SimpleBudgetWeb.GoalLive.Edit do
  alias SimpleBudget.{Goal}
  import Ecto.Enum, only: [mappings: 2]
  require Logger
  use SimpleBudgetWeb, :live_view

  def mount(params, session, socket) do
    goal = SimpleBudget.Goals.get(session, params)
    changeset = SimpleBudget.Goal.changeset(goal)

    {:ok,
     socket
     |> assign(%{page_title: "Goals"})
     |> assign(%{
       changeset: changeset,
       goal: goal,
       identity: session["identity"],
       recurrance_mappings: mappings(Goal, :recurrance)
     })
     |> assign(%{
       spendable_today: SimpleBudget.Goals.spendable(%{"identity" => session["identity"]})
     })}
  end

  def handle_event("validate", %{"goal" => params}, socket) do
    changeset = SimpleBudget.Goal.changeset(socket.assigns.goal, params)

    {:noreply, socket |> assign(%{changeset: changeset})}
  end

  def handle_event("save", %{"goal" => params}, socket) do
    changeset = SimpleBudget.Goal.changeset(socket.assigns.goal, params)

    case changeset.valid? do
      false ->
        {:noreply, socket |> assign(:changeset, changeset)}

      true ->
        SimpleBudget.Goals.save(changeset)
        {:noreply, socket |> push_navigate(to: "/goals")}
    end
  end
end
