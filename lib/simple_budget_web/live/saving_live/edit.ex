defmodule SimpleBudgetWeb.SavingLive.Edit do
  use SimpleBudgetWeb, :live_view
  require Logger

  def mount(%{"id" => id} = params, session, socket) when is_bitstring(id) do
    saving = SimpleBudget.Savings.get(session, params)
    changeset = SimpleBudget.Saving.changeset(saving)

    {:ok,
     socket
     |> assign(%{page_title: "Savings"})
     |> assign(%{changeset: changeset, saving: saving})}
  end

  def mount(%{}, session, socket) do
    saving = SimpleBudget.Savings.new(session)
    changeset = SimpleBudget.Saving.changeset(saving)

    {:ok,
     socket
     |> assign(%{page_title: "Savings"})
     |> assign(%{changeset: changeset, saving: saving})}
  end

  def handle_event("validate", %{"saving" => params}, socket) do
    changeset = SimpleBudget.Saving.changeset(socket.assigns.saving, params)
    {:noreply, socket |> assign(:changeset, changeset)}
  end

  def handle_event("save", %{"saving" => params}, socket) do
    changeset = SimpleBudget.Saving.changeset(socket.assigns.saving, params)

    case changeset.valid? do
      false ->
        {:noreply, socket |> assign(:changeset, changeset)}

      true ->
        Logger.info("saving changeset: #{changeset |> inspect()}")
        SimpleBudget.Savings.save(changeset)
        {:noreply, socket |> redirect(to: "/savings")}
    end
  end
end
