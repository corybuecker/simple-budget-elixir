defmodule SimpleBudget.Repo.Migrations.DropNotNullFromGoalsInitialDate do
  use Ecto.Migration

  def change do
    alter table(:goals) do
      modify(:initial_date, :date, null: true)
    end
  end
end
