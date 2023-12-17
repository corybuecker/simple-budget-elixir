defmodule SimpleBudget.Repo.Migrations.CreateSavings do
  use Ecto.Migration

  def change do
    create table(:savings) do
      add :name, :string, null: false
      add :total, :decimal, null: false
      add :user_id, references(:users, on_delete: :nothing), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:savings, [:user_id])
  end
end
