defmodule SimpleBudgetWeb.LoginHTML do
  use SimpleBudgetWeb, :html
  attr :url, :string, required: true

  def new(assigns) do
    ~H"""
    <div class="flex pt-24 px-24">
      <.link href={assigns.url}>
        Log in
      </.link>
    </div>
    """
  end
end
