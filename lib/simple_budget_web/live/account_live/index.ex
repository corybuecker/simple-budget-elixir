defmodule SimpleBudgetWeb.AccountLive.Index do
  use SimpleBudgetWeb, :live_view
  require Logger

  def mount(_params, session, socket) do
    user = SimpleBudget.Users.get_by_identity(session["identity"])

    {
      :ok,
      socket
      |> assign(:page_title, "Accounts")
      |> assign(:preferences, user.preferences)
      |> assign(:identity, user.identity)
      |> stream(:accounts, SimpleBudget.Accounts.all(user))
    }
  end

  def handle_event("delete", params, socket) do
    account = SimpleBudget.Accounts.delete(%{identity: socket.assigns.identity}, params)

    {:noreply, socket |> stream_delete(:accounts, account)}
  end

  def handle_event("update_preferences", %{"layout" => value}, socket) do
    with {:ok, identity} <- socket.assigns() |> Map.fetch(:identity),
         user <- SimpleBudget.Users.get_by_identity(identity) do
      SimpleBudget.Users.update(user, %{
        "preferences" => %{"layout" => value}
      })

      user = SimpleBudget.Users.get_by_identity(identity)
      accounts = SimpleBudget.Accounts.all(user)

      {:noreply,
       socket
       |> assign(:preferences, user.preferences)
       |> stream(:accounts, accounts, reset: true)}
    else
      anything ->
        Logger.error(anything)
        {:noreply, socket}
    end
  end

  def render(assigns) do
    ~H"""
    <div class="flex">
      <.link navigate="/accounts/new" class="p-1 border border-slate-400 rounded">New</.link>
    </div>
    <div>
      <.live_component
        id="accounts"
        module={SimpleBudgetWeb.Accounts.Layout}
        preferences={@preferences}
        accounts={@streams.accounts}
      />
    </div>
    """
  end
end
