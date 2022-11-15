defmodule SimpleBudgetWeb.SharedView do
  require Logger
  use SimpleBudgetWeb, :view

  def navigation_class(expected_title, %{page_title: current_title}) do
    case expected_title == current_title do
      true ->
        "bg-slate-700 text-white px-3 py-2 rounded-md text-sm"

      _ ->
        "text-black dark:text-white hover:bg-slate-700 hover:text-white px-3 py-2 rounded-md text-sm"
    end
  end
end
