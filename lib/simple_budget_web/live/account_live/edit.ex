defmodule SimpleBudgetWeb.AccountLive.Edit do
  use SimpleBudgetWeb, :live_view
  require Logger

  def mount(params, session, socket) do
    user = SimpleBudget.Users.get_by_identity(session["identity"])
    account = SimpleBudget.Accounts.get(session, params)

    {:ok,
     socket
     |> assign(page_title: "Accounts")
     |> assign(preferences: user.preferences)
     |> assign(account: account)
     |> assign(identity: session["identity"])
     |> assign(form: to_form(SimpleBudget.Account.changeset(account)))}
  end

  def handle_event("validate", %{"account" => params}, socket) do
    {:noreply,
     socket
     |> assign(
       :form,
       SimpleBudget.Account.changeset(socket.assigns.account, params)
       |> Map.put(:action, :validate)
       |> to_form()
     )}
  end

  def handle_event("save", %{"account" => params}, socket) do
    result =
      SimpleBudget.Account.changeset(socket.assigns.account, params)
      |> SimpleBudget.Accounts.save()

    case result do
      {:error, changeset} ->
        {:noreply, socket |> assign(:form, changeset |> to_form())}

      {:ok, _} ->
        {:noreply, socket |> push_navigate(to: "/accounts")}
    end
  end

  def render(assigns) do
    ~H"""
    <%= if @preferences.show_changeset do %>
      <%= @form |> inspect() %>
    <% end %>

    <.form for={@form} phx-change="validate" phx-submit="save">
      <div>
        <.text_input label="Name" field={@form[:name]} />
        <.text_input
          field={@form[:balance]}
          inputmode="decimal"
          label="Balance"
          min="0"
          step="0.01"
          type="number"
        />
        <.toggle field={@form[:debt]} label="Debt" />
        <div>
          <.custom_button type="submit">Save</.custom_button>
          <.link navigate="/accounts">Cancel</.link>
        </div>
      </div>
    </.form>
    """
  end
end
