defmodule SimpleBudgetWeb.Toggle do
  use SimpleBudgetWeb, :html

  attr :current, :atom, required: true

  def render(assigns) do
    ~H"""
    <.toggle_option
      name="layout"
      value="automatic"
      checked={@current === :automatic}
      class="peer/automatic"
    />
    <.toggle_option name="layout" value="grid" checked={@current === :grid} class="peer/grid" />
    <.toggle_option name="layout" value="list" checked={@current === :list} class="peer/list" />

    <.preference_label for="grid" class="peer-checked/grid:text-blue-600">
      <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" class="w-6 h-6">
        <path
          fill-rule="evenodd"
          d="M1.5 5.625c0-1.036.84-1.875 1.875-1.875h17.25c1.035 0 1.875.84 1.875 1.875v12.75c0 1.035-.84 1.875-1.875 1.875H3.375A1.875 1.875 0 011.5 18.375V5.625zM21 9.375A.375.375 0 0020.625 9h-7.5a.375.375 0 00-.375.375v1.5c0 .207.168.375.375.375h7.5a.375.375 0 00.375-.375v-1.5zm0 3.75a.375.375 0 00-.375-.375h-7.5a.375.375 0 00-.375.375v1.5c0 .207.168.375.375.375h7.5a.375.375 0 00.375-.375v-1.5zm0 3.75a.375.375 0 00-.375-.375h-7.5a.375.375 0 00-.375.375v1.5c0 .207.168.375.375.375h7.5a.375.375 0 00.375-.375v-1.5zM10.875 18.75a.375.375 0 00.375-.375v-1.5a.375.375 0 00-.375-.375h-7.5a.375.375 0 00-.375.375v1.5c0 .207.168.375.375.375h7.5zM3.375 15h7.5a.375.375 0 00.375-.375v-1.5a.375.375 0 00-.375-.375h-7.5a.375.375 0 00-.375.375v1.5c0 .207.168.375.375.375zm0-3.75h7.5a.375.375 0 00.375-.375v-1.5A.375.375 0 0010.875 9h-7.5A.375.375 0 003 9.375v1.5c0 .207.168.375.375.375z"
          clip-rule="evenodd"
        />
      </svg>
    </.preference_label>

    <.preference_label for="automatic" class="peer-checked/automatic:text-blue-600">
      Auto
    </.preference_label>

    <.preference_label for="list" class="peer-checked/list:text-blue-600">
      <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" class="w-6 h-6">
        <path
          fill-rule="evenodd"
          d="M2.625 6.75a1.125 1.125 0 112.25 0 1.125 1.125 0 01-2.25 0zm4.875 0A.75.75 0 018.25 6h12a.75.75 0 010 1.5h-12a.75.75 0 01-.75-.75zM2.625 12a1.125 1.125 0 112.25 0 1.125 1.125 0 01-2.25 0zM7.5 12a.75.75 0 01.75-.75h12a.75.75 0 010 1.5h-12A.75.75 0 017.5 12zm-4.875 5.25a1.125 1.125 0 112.25 0 1.125 1.125 0 01-2.25 0zm4.875 0a.75.75 0 01.75-.75h12a.75.75 0 010 1.5h-12a.75.75 0 01-.75-.75z"
          clip-rule="evenodd"
        />
      </svg>
    </.preference_label>
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
