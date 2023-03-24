defmodule SimpleBudgetWeb.Toggle do
  use SimpleBudgetWeb, :html

  attr :current, :atom, required: true

  def render(assigns) do
    ~H"""
    <div class="flex items-center gap-2 p-1 lg:gap-3 lg:p-2 bg-white rounded-md">
      <.toggle_option name="layout" value="grid" checked={@current === :grid} class="peer/grid" />
      <.toggle_option name="layout" value="list" checked={@current === :list} class="peer/list" />

      <.preference_label for="grid" class="peer-checked/grid:text-blue-600 h-6">
        <Heroicons.table_cells class="h-full" />
      </.preference_label>

      <.preference_label for="list" class="peer-checked/list:text-blue-600 h-6">
        <Heroicons.list_bullet class="h-full" />
      </.preference_label>
    </div>
    """
  end

  attr :class, :string, required: true
  attr :for, :string, required: true
  slot :inner_block, required: true

  defp preference_label(assigns) do
    ~H"""
    <label class={[@class, "cursor-pointer"]} for={@for} class="cursor-pointer">
      <%= render_slot(@inner_block) %>
    </label>
    """
  end

  attr :name, :string, required: true
  attr :value, :string, required: true
  attr :checked, :boolean, default: false
  attr :class, :string, required: true

  defp toggle_option(assigns) do
    ~H"""
    <input
      phx-click="update_preferences"
      phx-value-layout={@value}
      checked={@checked}
      class={[@class, "hidden"]}
      name={@name}
      id={@value}
      type="radio"
    />
    """
  end
end
