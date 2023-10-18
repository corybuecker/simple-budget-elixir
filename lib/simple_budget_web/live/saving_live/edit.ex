defmodule SimpleBudgetWeb.SavingLive.Edit do
  use SimpleBudgetWeb, :live_view

  def mount(params, session, socket) do
    saving = SimpleBudget.Savings.get(session, params)
    changeset = SimpleBudget.Saving.changeset(saving)
    user = SimpleBudget.Users.get_by_identity(session["identity"])

    {:ok,
     socket
     |> assign(page_title: "Savings")
     |> assign(preferences: user.preferences)
     |> assign(form: changeset |> to_form())
     |> assign(saving: saving)}
  end

  def handle_event("validate", %{"saving" => params}, socket) do
    {:noreply,
     socket
     |> assign(
       :form,
       SimpleBudget.Saving.changeset(socket.assigns.saving, params)
       |> Map.put(:action, :validate)
       |> to_form()
     )}
  end

  def handle_event("save", %{"saving" => params}, socket) do
    result =
      SimpleBudget.Saving.changeset(socket.assigns.saving, params)
      |> SimpleBudget.Savings.save()

    case result do
      {:error, changeset} ->
        {:noreply, socket |> assign(:form, changeset |> to_form())}

      {:ok, _} ->
        {:noreply, socket |> push_navigate(to: "/savings")}
    end
  end

  def render(assigns) do
    ~H"""
    <%= if @preferences.show_changeset do %>
      <%= @form |> inspect() %>
    <% end %>
    <.form class="flex flex-col gap-2" for={@form} phx-change="validate" phx-submit="save">
      <.text_input field={@form[:name]} label="Name" />
      <.text_input
        field={@form[:amount]}
        inputmode="decimal"
        label="Amount"
        min="0"
        step="0.01"
        type="number"
      />
      <div>
        <.custom_button type="submit">Save</.custom_button>
        <.link class="underline" navigate="/accounts">Cancel</.link>
      </div>
    </.form>
    """
  end
end
