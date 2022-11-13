defmodule SimpleBudgetWeb.Button do
  use Phoenix.Component

  slot(:inner_block, required: true)
  attr(:rest, :global)

  @spec render(map) :: Phoenix.LiveView.Rendered.t()
  def render(assigns \\ %{}) do
    ~H"""
    <button
      {@rest}
      class="px-5 py-2.5 font-medium bg-blue-50 hover:bg-blue-100 hover:text-blue-600 text-blue-500 rounded-lg text-sm"
    >
      <%= render_slot(@inner_block) %>
    </button>
    """
  end
end
