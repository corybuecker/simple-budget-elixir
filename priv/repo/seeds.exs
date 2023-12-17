# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     SimpleBudget.Repo.insert!(%SimpleBudget.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

%SimpleBudget.User{id: user_id} =
  SimpleBudget.Repo.insert!(
    SimpleBudget.User.changeset(%SimpleBudget.User{}, %{
      email: System.get_env("ADMIN_EMAIL"),
      identity: Ecto.UUID.generate(),
      preferences: %{}
    })
  )

Enum.each(1..25, fn i ->
  SimpleBudget.Repo.insert!(
    SimpleBudget.Account.changeset(%SimpleBudget.Account{user_id: user_id}, %{
      name: "Account #{i}",
      balance: Decimal.new(Enum.random(1..1000))
    })
  )
end)

Enum.each(1..2, fn i ->
  SimpleBudget.Repo.insert!(
    SimpleBudget.Saving.changeset(%SimpleBudget.Saving{user_id: user_id}, %{
      name: "Saving #{i}",
      total: Decimal.new(Enum.random(1..1000))
    })
  )
end)

Enum.each(1..2, fn i ->
  SimpleBudget.Repo.insert!(
    SimpleBudget.Goal.changeset(%SimpleBudget.Goal{user_id: user_id}, %{
      name: "Goal #{i}",
      amount: Decimal.new(Enum.random(1..1000)),
      recurrance: :monthly,
      target_date: Date.utc_today(),
      initial_date: Date.utc_today()
    })
  )
end)
