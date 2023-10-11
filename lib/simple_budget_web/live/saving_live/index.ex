defmodule SimpleBudgetWeb.SavingLive.Index do
  use SimpleBudgetWeb, :live_view
  require Logger

  def mount(_params, session, socket) do
    user = SimpleBudget.Users.get_by_identity(session["identity"])

    {:ok,
     socket
     |> assign(page_title: "Savings")
     |> assign(identity: user.identity)
     |> assign(preferences: user.preferences)
     |> stream(:savings, SimpleBudget.Savings.all(session))}
  end

  def handle_event("delete", params, socket) do
    deleted_saving = SimpleBudget.Savings.delete(socket.assigns, params)

    {:noreply, socket |> stream_delete(:savings, deleted_saving)}
  end

  def handle_event("update_preferences", %{"layout" => value}, socket) do
    with {:ok, identity} <- socket.assigns() |> Map.fetch(:identity),
         user <- SimpleBudget.Users.get_by_identity(identity) do
      SimpleBudget.Users.update(user, %{
        "preferences" => %{"layout" => value}
      })

      user = SimpleBudget.Users.get_by_identity(identity)
      savings = SimpleBudget.Savings.all(user)

      {:noreply,
       socket
       |> assign(:preferences, user.preferences)
       |> stream(:savings, savings, reset: true)}
    else
      anything ->
        Logger.error(anything)
        {:noreply, socket}
    end
  end

  def render(assigns) do
    ~H"""
    <div>
      <.link navigate="/savings/new">New</.link>
    </div>
    <div>
      <.live_component
        id="savings"
        module={SimpleBudgetWeb.Savings.Layout}
        preferences={@preferences}
        savings={@streams.savings}
      />
    </div>
    """
  end
end
