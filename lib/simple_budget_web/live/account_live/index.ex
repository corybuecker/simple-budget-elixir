defmodule SimpleBudgetWeb.AccountLive.Index do
  use SimpleBudgetWeb, :live_view
  require Logger

  def mount(_params, session, socket) do
    {:ok,
     socket
     |> assign(%{page_title: "Accounts"})
     |> assign(%{accounts: SimpleBudget.Accounts.all(session), identity: session["identity"]})}
  end

  def handle_event("delete", params, socket) do
    SimpleBudget.Accounts.delete(socket.assigns, params)

    {:noreply, socket |> assign(:accounts, SimpleBudget.Accounts.all(socket.assigns))}
  end

  def handle_event("update_preferences", %{"layout" => value}, socket) do
    Logger.debug(value)

    with {:ok, identity} <- socket.assigns() |> Map.fetch(:identity),
         user <- SimpleBudget.Users.get_by_identity(identity) do
      SimpleBudget.Users.update(user, %{
        "preferences" => %{"accounts_layout" => value}
      })
    else
      anything ->
        Logger.error(anything)
    end

    {:noreply, socket}
  end
end
