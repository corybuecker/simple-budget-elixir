defmodule SimpleBudgetWeb.LayoutView do
  use SimpleBudgetWeb, :view

  # Phoenix LiveDashboard is available only in development by default,
  # so we instruct Elixir to not warn if the dashboard route is missing.
  @compile {:no_warn_undefined, {Routes, :live_dashboard_path, 2}}

  def navigation_class(expected_title, %{page_title: current_title}) do
    case expected_title == current_title do
      true ->
        "bg-slate-600 text-white px-3 py-2 rounded-md text-sm"

      _ ->
        "text-white hover:bg-slate-600 px-3 py-2 rounded-md text-sm"
    end
  end
end
