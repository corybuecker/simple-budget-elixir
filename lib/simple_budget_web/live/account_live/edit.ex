defmodule SimpleBudgetWeb.AccountLive.Edit do
  use SimpleBudgetWeb, :live_view
  require Logger

  def mount(params, session, socket) do
    account = SimpleBudget.Accounts.get(session, params)
    changeset = SimpleBudget.Account.changeset(account)

    {:ok,
     socket
     |> assign(%{page_title: "Accounts | Simple Budget"})
     |> assign(%{changeset: changeset, account: account})}
  end

  def handle_event("validate", %{"account" => params}, socket) do
    changeset = SimpleBudget.Account.changeset(socket.assigns.account, params)
    {:noreply, socket |> assign(:changeset, changeset)}
  end

  def handle_event("save", %{"account" => params}, socket) do
    changeset = SimpleBudget.Account.changeset(socket.assigns.account, params)

    case changeset.valid? do
      false ->
        {:noreply, socket |> assign(:changeset, changeset)}

      true ->
        Logger.info("saving changeset: #{changeset |> inspect()}")
        SimpleBudget.Accounts.save(changeset)
        {:noreply, socket |> redirect(to: "/accounts")}
    end
  end
end
