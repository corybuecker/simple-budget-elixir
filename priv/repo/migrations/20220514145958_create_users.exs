defmodule SimpleBudget.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string, null: false
      add :identity, :uuid, null: false, default: fragment("gen_random_uuid()")
      timestamps()
    end

    create index(:users, :email, unique: true)
  end
end
