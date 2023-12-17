defmodule SimpleBudgetWeb.SavingsController do
  use SimpleBudgetWeb, :controller
  import Phoenix.Component, only: [to_form: 1]
  require Logger

  def index(conn, _) do
    savings = SimpleBudget.Saving.list_savings()
    conn |> render(%{savings: savings})
  end

  def new(conn, _) do
    changeset = Ecto.Changeset.change(%SimpleBudget.Saving{})
    conn |> render(form: to_form(changeset))
  end

  def create(conn, %{"saving" => saving_params}) do
    user = SimpleBudget.User.get_by_identity(conn |> get_session(:identity))

    changeset =
      SimpleBudget.Saving.changeset(%SimpleBudget.Saving{user_id: user.id}, saving_params)

    case SimpleBudget.Repo.insert(changeset) do
      {:ok, _saving} ->
        conn
        |> put_flash(:info, "Saving created successfully.")
        |> redirect(to: ~p"/savings")

      {:error, changeset} ->
        conn
        |> put_flash(:error, "Saving could not be created.")
        |> render("new.html", changeset: changeset)
    end
  end

  def show(conn, query) do
    saving = SimpleBudget.User.savings(conn |> get_session, query)
    conn |> render("show.html", saving: saving)
  end

  def edit(conn, query) do
    saving = SimpleBudget.User.savings(conn |> get_session, query)
    conn |> render("edit.html", form: saving |> Ecto.Changeset.change() |> to_form())
  end

  def update(conn, params) do
    saving = SimpleBudget.User.savings(conn |> get_session, params)
    changeset = SimpleBudget.Saving.changeset(saving, params["saving"])

    case SimpleBudget.Repo.update(changeset) do
      {:ok, saving} ->
        conn
        |> put_flash(:info, "Saving updated successfully.")
        |> redirect(to: ~p"/savings/#{saving.id}/edit")

      {:error, changeset} ->
        Logger.debug(inspect(changeset))

        conn
        |> put_flash(:error, "Something went wrong.")
        |> put_status(:unprocessable_entity)
        |> render("edit.html", form: changeset |> to_form())
    end
  end

  def delete(conn, query) do
    saving = SimpleBudget.User.savings(conn |> get_session, query)
    SimpleBudget.Repo.delete!(saving)

    conn
    |> put_flash(:info, "Saving deleted successfully.")
    |> redirect(to: ~p"/savings")
  end
end
