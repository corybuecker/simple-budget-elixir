defmodule SimpleBudget.Repo.Migrations.SoftDeleteTransactions do
  use Ecto.Migration

  def change do
    alter(table(:transactions)) do
      add(:archived, :boolean, default: false, null: false)
    end
  end
end
