defmodule SimpleBudget.Repo.Migrations.CreateGoals do
  use Ecto.Migration

  def change do
    create table(:goals) do
      add :name, :string, null: false
      add :amount, :decimal, null: false
      add :recurrance, :string, null: false
      add :initial_date, :date, null: false
      add :target_date, :date, null: false

      add :user_id, references(:users, on_delete: :nothing), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:goals, [:user_id])
  end
end
