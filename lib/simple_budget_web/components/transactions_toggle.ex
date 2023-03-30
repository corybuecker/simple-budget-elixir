defmodule SimpleBudgetWeb.TransactionsToggle do
  use SimpleBudgetWeb, :html

  def render(assigns) do
    ~H"""
    <div class="flex items-center gap-2 p-1 lg:gap-3 lg:p-2 bg-white rounded-md">
      <a href={~p"/transactions/new"} class="h-6 hover:text-blue-600">
        <Heroicons.plus_circle class="h-full" />
      </a>
      <a href={~p"/transactions"} class="h-6 hover:text-blue-600">
        <Heroicons.trash class="h-full" />
      </a>
    </div>
    """
  end
end
