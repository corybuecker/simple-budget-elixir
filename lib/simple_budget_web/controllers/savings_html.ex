defmodule SimpleBudgetWeb.SavingsHTML do
  use SimpleBudgetWeb, :html

  attr :savings, :list, default: []

  def index(assigns) do
    ~H"""
    <h1>Savings</h1>
    <p><.link href={~p"/savings/new"}>New</.link></p>
    <%= for saving <- assigns.savings do %>
      <.list>
        <:item title="Name">
          <.link href={~p"/savings/#{saving.id}"}><%= saving.name %></.link>
        </:item>
        <:item title="Total"><%= saving.total %></:item>
        <:item title="Delete">
          <.link data-confirm="Are you sure?" href={~p"/savings/#{saving.id}"} method="delete">
            Delete
          </.link>
        </:item>
      </.list>
    <% end %>
    """
  end

  def show(assigns) do
    ~H"""
    <h1><%= assigns.saving.name %></h1>
    <p><.link href={~p"/savings/#{assigns.saving.id}/edit"}>Edit</.link></p>
    <.list>
      <:item title="Total"><%= assigns.saving.total %></:item>
    </.list>
    """
  end

  def new(assigns) do
    ~H"""
    <h1>New Saving</h1>
    <.saving_form for={assigns.form} method="post" action={~p"/savings"} />
    """
  end

  def edit(assigns) do
    ~H"""
    <h1>Edit Saving</h1>
    <.saving_form for={assigns.form} method="patch" action={~p"/savings/#{assigns.form.hidden[:id]}"} />
    """
  end

  attr :for, :any, required: true
  attr :method, :string, required: true
  attr :action, :string, required: true

  defp saving_form(assigns) do
    ~H"""
    <.simple_form for={assigns.for} action={assigns.action} method={assigns.method}>
      <.input field={@for[:name]} label="Name" />
      <.input field={@for[:total]} label="Total" />
      <:actions>
        <.button type="submit">Save</.button>
      </:actions>
    </.simple_form>
    """
  end
end
