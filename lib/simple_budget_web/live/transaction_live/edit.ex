defmodule SimpleBudgetWeb.TransactionsLive.Edit do
  use SimpleBudgetWeb, :live_view

  def mount(_params, session, socket) do
    transaction = SimpleBudget.Transactions.get(session)
    changeset = SimpleBudget.Transaction.changeset(transaction)

    {:ok,
     socket
     |> assign(%{page_title: "Transactions"})
     |> assign(%{changeset: changeset, transaction: transaction, identity: session["identity"]})}
  end

  def handle_event("save", %{"transaction" => params}, socket) do
    changeset = SimpleBudget.Transaction.changeset(socket.assigns.transaction, params)

    case changeset.valid? do
      false ->
        {:noreply, socket |> assign(:changeset, changeset)}

      true ->
        SimpleBudget.Transactions.save(changeset)
        {:noreply, socket |> push_navigate(to: "/")}
    end
  end
end
