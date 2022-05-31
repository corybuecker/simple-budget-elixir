defmodule SimpleBudget.Repo.Migrations.CreateGoals do
  use Ecto.Migration

  def change do
    create_query =
      "CREATE TYPE goal_recurrances AS ENUM ('weekly', 'daily', 'monthly', 'quarterly', 'yearly', 'never')"

    drop_query = "DROP TYPE goal_recurrances"
    execute(create_query, drop_query)

    create table(:goals) do
      add :name, :string, null: false
      add :amount, :decimal, null: false
      add :recurrance, :goal_recurrances, null: false, default: "monthly"
      add :target_date, :date, null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end
  end
end
