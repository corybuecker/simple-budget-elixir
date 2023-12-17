defmodule SimpleBudget.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string
      add :identity, :uuid, default: fragment("gen_random_uuid()"), null: false
      add :preferences, :map, default: %{}, null: false

      timestamps(type: :utc_datetime)
    end
  end
end
