defmodule SimpleBudgetWeb.TransactionsLive.Edit do
  use SimpleBudgetWeb, :live_view

  def mount(_params, session, socket) do
    transaction = SimpleBudget.Transactions.get(session)

    {:ok,
     socket
     |> assign(page_title: "Transactions")
     |> assign(form: SimpleBudget.Transaction.changeset(transaction) |> to_form())
     |> assign(transaction: transaction)
     |> assign(identity: session["identity"])}
  end

  def handle_event("save", %{"transaction" => params}, socket) do
    changeset = SimpleBudget.Transaction.changeset(socket.assigns.transaction, params)

    case changeset.valid? do
      false ->
        {:noreply, socket |> assign(:form, changeset |> to_form())}

      true ->
        SimpleBudget.Transactions.save(changeset)
        {:noreply, socket |> push_navigate(to: "/")}
    end
  end

  def render(assigns) do
    ~H"""
    <.form for={@form} phx-submit="save">
      <div>
        <.input field={@form[:amount]} type="number" inputmode="decimal" step="0.01" autofocus={true}>
        </.input>
        <.button class="w-full mt-4" type="submit">Save</.button>
      </div>
    </.form>
    """
  end
end
