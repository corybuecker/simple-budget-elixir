ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(SimpleBudget.Repo, :manual)
Application.put_env(SimpleBudget, :date_adapter, SimpleBudget.Utilities.FakeDate)
SimpleBudget.Utilities.FakeDate.start_link()
