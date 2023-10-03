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

  attr :type, :string, default: nil
  attr :class, :string, default: nil
  attr :rest, :global, include: ~w(disabled form name value)
  slot :inner_block, required: true

  def custom_button(assigns) do
    ~H"""
    <button
      type={@type}
      class={[
        "phx-submit-loading:opacity-75 rounded-lg py-2 px-3",
        "text-sm font-semibold leading-6 text-black active:text-white/80",
        @class
      ]}
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </button>
    """
  end
end
