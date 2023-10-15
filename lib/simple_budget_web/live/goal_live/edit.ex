defmodule SimpleBudgetWeb.GoalLive.Edit do
  alias SimpleBudget.Goal
  import Ecto.Enum, only: [mappings: 2]
  require Logger
  use SimpleBudgetWeb, :live_view

  def mount(params, session, socket) do
    goal = SimpleBudget.Goals.get(session, params)
    changeset = SimpleBudget.Goal.changeset(goal)

    {:ok,
     socket
     |> assign(page_title: "Goals")
     |> assign(form: changeset |> to_form())
     |> assign(goal: goal)
     |> assign(identity: session["identity"])
     |> assign(recurrance_mappings: mappings(Goal, :recurrance))
     |> assign(
       spendable_today: SimpleBudget.Goals.spendable(%{"identity" => session["identity"]})
     )}
  end

  def handle_event("validate", %{"goal" => params}, socket) do
    {:noreply,
     socket |> assign(form: SimpleBudget.Goal.changeset(socket.assigns.goal, params) |> to_form())}
  end

  def handle_event("save", %{"goal" => params}, socket) do
    changeset =
      SimpleBudget.Goal.changeset(socket.assigns.goal, params)

    result =
      changeset
      |> SimpleBudget.Goals.save()

    case result do
      {:error, changeset} ->
        {:noreply, socket |> assign(:form, changeset |> to_form())}

      {:ok, _} ->
        {:noreply, socket |> push_navigate(to: "/goals")}
    end
  end

  def render(assigns) do
    ~H"""
    <.form for={@form} phx-change="validate" phx-submit="save">
      <div>
        <.text_input field={@form[:name]} label="Name" />
        <.text_input field={@form[:amount]} label="Amount" />
        <.text_input field={@form[:recurrance]} label="Recurrance" />
        <.input
          id="goal-datepicker"
          phx-hook="DatePicker"
          field={@form[:target_date]}
          label="Target date"
        />

        <.button type="submit">Save</.button>
      </div>
    </.form>
    """
  end
end
