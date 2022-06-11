defmodule SimpleBudget.PrivateGoals do
  alias SimpleBudget.{Goal, Repo}
  import Ecto.{Query}
  require Logger

  def expired() do
    today = Date.utc_today()

    Repo.all(
      from a in Goal,
        select: a,
        where: a.target_date < ^today
    )
  end
end
