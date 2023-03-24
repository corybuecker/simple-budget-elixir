defmodule SimpleBudgetWeb.AccountLive.Index do
  use SimpleBudgetWeb, :live_view
  require Logger

  def mount(_params, session, socket) do
    user = SimpleBudget.Users.get_by_identity(session["identity"])

    {
      :ok,
      socket
      |> assign(:page_title, "Accounts")
      |> assign(:preferences_layout, user.preferences.layout)
      |> assign(:user, user)
      |> stream(:accounts, SimpleBudget.Accounts.all(user))
    }
  end

  def handle_event("delete", params, socket) do
    account = SimpleBudget.Accounts.delete(%{identity: socket.assigns.user.identity}, params)

    {:noreply, socket |> stream_delete(:accounts, account)}
  end

  def handle_event("update_preferences", %{"layout" => value}, socket) do
    with {:ok, user} <- socket.assigns() |> Map.fetch(:user),
         {:ok, _} <-
           SimpleBudget.Users.update(user, %{
             "preferences" => %{"layout" => value}
           }),
         user <- SimpleBudget.Users.reload(user) do
      {:noreply,
       socket
       |> assign(:user, user)
       |> assign(:preferences_layout, user.preferences.layout)
       |> redirect(to: ~p"/accounts")}
    else
      error ->
        {:noreply, socket |> put_flash(:error, error |> inspect())}
    end
  end
end
