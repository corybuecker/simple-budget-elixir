defmodule SimpleBudgetWeb.GoalsHTML do
  use SimpleBudgetWeb, :html

  attr :goals, :list, default: []

  def index(assigns) do
    ~H"""
    <h1>Goals</h1>
    <p><.link href={~p"/goals/new"}>New</.link></p>
    <%= for goal <- assigns.goals do %>
      <.list>
        <:item title="Name">
          <.link href={~p"/goals/#{goal.id}"}><%= goal.name %></.link>
        </:item>
        <:item title="Amount"><%= goal.amount |> Number.Currency.number_to_currency() %></:item>
        <:item title="Recurrance"><%= goal.recurrance %></:item>
        <:item title="Initial Date"><%= goal.initial_date %></:item>
        <:item title="Target Date"><%= goal.target_date %></:item>
        <:item title="Amortized"><%= goal.amortized |> Number.Currency.number_to_currency() %></:item>
        <:item title="Delete">
          <.link data-confirm="Are you sure?" href={~p"/goals/#{goal.id}"} method="delete">
            Delete
          </.link>
        </:item>
      </.list>
    <% end %>
    """
  end

  def show(assigns) do
    ~H"""
    <h1><%= assigns.goal.name %></h1>
    <p><.link href={~p"/goals/#{assigns.goal.id}/edit"}>Edit</.link></p>
    <.list>
      <:item title="Amount"><%= assigns.goal.amount %></:item>
      <:item title="Recurrance"><%= assigns.goal.recurrance %></:item>
      <:item title="Initial Date"><%= assigns.goal.initial_date %></:item>
      <:item title="Target Date"><%= assigns.goal.target_date %></:item>
    </.list>
    """
  end

  def new(assigns) do
    ~H"""
    <h1>New Goal</h1>
    <.goal_form for={assigns.form} method="post" action={~p"/goals"} />
    """
  end

  def edit(assigns) do
    ~H"""
    <h1>Edit Goal</h1>
    <.goal_form for={assigns.form} method="patch" action={~p"/goals/#{assigns.form.hidden[:id]}"} />
    """
  end

  attr :for, :any, required: true
  attr :method, :string, required: true
  attr :action, :string, required: true

  defp goal_form(assigns) do
    ~H"""
    <.simple_form for={assigns.for} action={assigns.action} method={assigns.method}>
      <.input required field={@for[:name]} label="Name" />
      <.input required field={@for[:amount]} label="Amount" />
      <.input
        required
        type="select"
        field={@for[:recurrance]}
        label="Recurrance"
        options={["daily", "weekly", "monthly", "yearly"]}
      />
      <.input type="date" field={@for[:initial_date]} label="Initial Date" />
      <.input required type="date" field={@for[:target_date]} label="Target Date" />
      <:actions>
        <.button type="submit">Save</.button>
      </:actions>
    </.simple_form>
    """
  end
end
