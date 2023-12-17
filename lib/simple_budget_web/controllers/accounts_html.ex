defmodule SimpleBudgetWeb.AccountsHTML do
  use SimpleBudgetWeb, :html

  attr :accounts, :list, default: []

  def index(assigns) do
    ~H"""
    <h1>Accounts</h1>
    <p><.link href={~p"/accounts/new"}>New</.link></p>
    <%= for account <- assigns.accounts do %>
      <.list>
        <:item title="Name">
          <.link href={~p"/accounts/#{account.id}"}><%= account.name %></.link>
        </:item>
        <:item title="Balance"><%= account.balance %></:item>
        <:item title="Debt"><%= account.debt %></:item>
        <:item title="Delete">
          <.link data-confirm="Are you sure?" href={~p"/accounts/#{account.id}"} method="delete">
            Delete
          </.link>
        </:item>
      </.list>
    <% end %>
    """
  end

  def edit(assigns) do
    ~H"""
    <h1>Edit Account</h1>
    <.account_form
      for={assigns.form}
      method="patch"
      action={~p"/accounts/#{assigns.form.hidden[:id]}"}
    />
    """
  end

  def show(assigns) do
    ~H"""
    <h1><%= assigns.account.name %></h1>
    <p><.link href={~p"/accounts/#{assigns.account.id}/edit"}>Edit</.link></p>
    <.list>
      <:item title="Balance"><%= assigns.account.balance %></:item>
      <:item title="Debt"><%= assigns.account.debt %></:item>
    </.list>
    """
  end

  def new(assigns) do
    ~H"""
    <h1>New Account</h1>
    <.account_form for={assigns.form} method="post" action={~p"/accounts"} />
    """
  end

  attr :for, :any, required: true
  attr :method, :string, required: true
  attr :action, :string, required: true

  defp account_form(assigns) do
    ~H"""
    <.simple_form for={assigns.for} action={assigns.action} method={assigns.method}>
      <.input field={@for[:name]} label="Name" />
      <.input field={@for[:balance]} label="Balance" />
      <.input type="checkbox" field={@for[:debt]} label="Debt" />
      <:actions>
        <.button>Submit</.button>
      </:actions>
    </.simple_form>
    """
  end
end
