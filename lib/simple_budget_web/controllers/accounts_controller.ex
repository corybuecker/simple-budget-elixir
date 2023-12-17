defmodule SimpleBudgetWeb.AccountsController do
  use SimpleBudgetWeb, :controller
  require Logger
  import Phoenix.Component, only: [to_form: 1]

  def index(conn, _) do
    accounts = SimpleBudget.User.accounts(conn |> get_session)
    conn |> render(accounts: accounts)
  end

  def show(conn, query) do
    account = SimpleBudget.User.accounts(conn |> get_session, query)
    conn |> render(account: account)
  end

  def edit(conn, query) do
    account = SimpleBudget.User.accounts(conn |> get_session, query)
    conn |> render(form: account |> Ecto.Changeset.change() |> Phoenix.Component.to_form())
  end

  def update(conn, params) do
    account = SimpleBudget.User.accounts(conn |> get_session, params)
    changeset = SimpleBudget.Account.changeset(account, params["account"])

    case SimpleBudget.Repo.update(changeset) do
      {:ok, account} ->
        conn
        |> put_flash(:info, "Account updated successfully.")
        |> redirect(to: ~p"/accounts/#{account.id}")

      {:error, changeset} ->
        conn
        |> put_flash(:error, "Something went wrong.")
        |> put_status(:unprocessable_entity)
        |> render("edit.html", form: changeset |> to_form())
    end
  end

  def new(conn, _params) do
    conn
    |> render(form: Phoenix.Component.to_form(%SimpleBudget.Account{} |> Ecto.Changeset.change()))
  end

  def create(conn, %{"account" => account_params}) do
    user = SimpleBudget.User.get_by_identity(conn |> get_session(:identity))

    changeset =
      SimpleBudget.Account.changeset(%SimpleBudget.Account{user_id: user.id}, account_params)

    case SimpleBudget.Repo.insert(changeset) do
      {:ok, _account} ->
        conn
        |> put_flash(:info, "Account created successfully.")
        |> redirect(to: ~p"/accounts")

      {:error, changeset} ->
        conn
        |> put_flash(:error, "Something went wrong.")
        |> put_status(:unprocessable_entity)
        |> render("new.html", form: Phoenix.Component.to_form(changeset))
    end
  end

  def delete(conn, params) do
    account = SimpleBudget.User.accounts(conn |> get_session, params)
    account |> SimpleBudget.Repo.delete()

    conn
    |> put_flash(:info, "Account deleted successfully.")
    |> redirect(to: ~p"/accounts")
  end
end
