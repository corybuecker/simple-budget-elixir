defmodule SimpleBudget.Repo.Migrations.UniqueIdentities do
  use Ecto.Migration

  def change do
    create index(:users, :identity, unique: true)
  end
end
