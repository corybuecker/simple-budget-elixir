defmodule SimpleBudgetWeb.CustomComponents do
  use Phoenix.Component

  attr :name, :string, required: true
  attr :label, :string, required: true

  def text_input(assigns) do
    ~H"""
    <div class="flex flex-col">
      <label for={assigns.name}><%= assigns.label %></label>
      <input type="text" id={assigns.name} name={assigns.name} />
    </div>
    """
  end
end
