defmodule SimpleBudgetWeb.GoalsController do
  use SimpleBudgetWeb, :controller
  import Phoenix.Component, only: [to_form: 1]
  require Logger

  def index(conn, _) do
    goals =
      SimpleBudget.User.goals(conn |> get_session)
      |> Enum.map(fn goal ->
        Map.merge(goal, %{amortized: SimpleBudget.Goals.amortized_amount(goal)})
      end)

    conn |> render(goals: goals)
  end

  def show(conn, query) do
    goal = SimpleBudget.User.goals(conn |> get_session, query)
    conn |> render("show.html", goal: goal)
  end

  def new(conn, _) do
    conn |> render(form: %SimpleBudget.Goal{} |> Ecto.Changeset.change() |> to_form())
  end

  def edit(conn, params) do
    goal = SimpleBudget.User.goals(conn |> get_session, params)
    changeset = SimpleBudget.Goal.changeset(goal)
    conn |> render("edit.html", form: changeset |> to_form())
  end

  def create(conn, %{"goal" => goal_params}) do
    user = SimpleBudget.User.get_by_identity(conn |> get_session(:identity))
    changeset = SimpleBudget.Goal.changeset(%SimpleBudget.Goal{user_id: user.id}, goal_params)

    case SimpleBudget.Repo.insert(changeset) do
      {:ok, _goal} ->
        conn
        |> put_flash(:info, "Goal created successfully.")
        |> redirect(to: ~p"/goals")

      {:error, changeset} ->
        Logger.debug(inspect(changeset))

        conn
        |> put_flash(:error, "Goal could not be created.")
        |> put_status(:unprocessable_entity)
        |> render("new.html", form: changeset |> to_form())
    end
  end

  def update(conn, params) do
    goal = SimpleBudget.User.goals(conn |> get_session, params)
    changeset = SimpleBudget.Goal.changeset(goal, params["goal"])

    case SimpleBudget.Repo.update(changeset) do
      {:ok, goal} ->
        conn
        |> put_flash(:info, "Goal updated successfully.")
        |> redirect(to: ~p"/goals/#{goal.id}/edit")

      {:error, changeset} ->
        conn
        |> put_flash(:error, "Goal could not be updated.")
        |> put_status(:unprocessable_entity)
        |> render("edit.html", form: changeset |> to_form())
    end
  end

  def delete(conn, params) do
    goal = SimpleBudget.User.goals(conn |> get_session, params)

    goal |> SimpleBudget.Repo.delete()

    conn
    |> put_flash(:info, "Goal deleted successfully.")
    |> redirect(to: ~p"/goals")
  end
end
