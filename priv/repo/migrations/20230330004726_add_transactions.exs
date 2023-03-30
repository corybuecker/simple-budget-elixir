defmodule SimpleBudget.Repo.Migrations.AddTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :amount, :decimal, null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end
  end
end
