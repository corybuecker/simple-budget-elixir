defmodule SimpleBudgetWeb.CustomComponents do
  require Logger
  use Phoenix.Component

  attr :field, Phoenix.HTML.FormField
  attr :label, :string, required: true
  attr :error, :string
  attr :rest, :global, include: ~w(inputmode min step)

  def text_input(%{field: %Phoenix.HTML.FormField{}} = assigns) do
    error =
      case assigns.field.errors do
        [{error, _} | _] -> error
        _ -> nil
      end

    assigns = assign(assigns, :error, error)

    ~H"""
    <div phx-feedback-for={@field.name} class="flex flex-col">
      <label class="leading-none pb-1" for={@field.name}><%= @label %></label>
      <input type="text" id={@field.name} name={@field.name} value={@field.value} {@rest} />
      <%= if @error do %>
        <div class="phx-no-feedback:hidden text-sm"><%= @error %></div>
      <% end %>
    </div>
    """
  end

  attr :type, :string, default: nil
  attr :rest, :global, include: ~w(disabled form name value)
  slot :inner_block, required: true

  def custom_button(assigns) do
    ~H"""
    <button type={@type} {@rest}>
      <%= render_slot(@inner_block) %>
    </button>
    """
  end

  attr :field, Phoenix.HTML.FormField
  attr :label, :string, required: true

  def toggle(%{field: %Phoenix.HTML.FormField{}} = assigns) do
    ~H"""
    <label class="cursor-pointer flex gap-2">
      <input
        value="true"
        name={@field.name}
        type="checkbox"
        checked={@field.value == true}
        class="peer sr-only"
      />
      <div class="border border-zinc-800 bg-slate-400 px-px py-px w-11 inline-flex peer-checked:justify-end rounded-full">
        <div class="bg-white w-5 h-5 rounded-full"></div>
      </div>
      <%= @label %>
    </label>
    """
  end
end
