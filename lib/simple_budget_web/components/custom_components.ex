defmodule SimpleBudgetWeb.CustomComponents do
  use Phoenix.Component

  attr :field, Phoenix.HTML.FormField
  attr :label, :string, required: true
  attr :error, :string
  attr :rest, :global

  def text_input(%{field: %Phoenix.HTML.FormField{}} = assigns) do
    error =
      case assigns.field.errors do
        [{error, _} | _] -> error
        _ -> nil
      end

    assigns = assign(assigns, :error, error)

    ~H"""
    <div phx-feedback-for={@field.name} class="flex flex-col">
      <label for={@field.name}><%= @label %></label>
      <input type="text" id={@field.name} name={@field.name} value={@field.value} {@rest} />
      <%= if @error do %>
        <div class="phx-no-feedback:hidden text-sm"><%= @error %></div>
      <% end %>
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
