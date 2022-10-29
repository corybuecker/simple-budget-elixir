defmodule SimpleBudgetWeb.SharedView do
  require Logger
  use SimpleBudgetWeb, :view

  def navigation_class(expected_title, %{page_title: current_title}) do
    case expected_title == current_title do
      true ->
        "bg-gray-900 text-white px-3 py-2 rounded-md text-sm font-medium"

      _ ->
        "text-gray-300 hover:bg-gray-700 hover:text-white px-3 py-2 rounded-md text-sm font-medium"
    end
  end
end
