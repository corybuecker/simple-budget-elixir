defmodule SimpleBudget.Repo.Migrations.CreateSavings do
  use Ecto.Migration

  def change do
    create table(:savings) do
      add :name, :string, null: false
      add :amount, :decimal, null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end
  end
end
