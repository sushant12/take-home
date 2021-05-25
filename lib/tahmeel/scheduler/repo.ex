defmodule Tahmeel.Scheduler.Repo do
  alias Tahmeel.Repo
  alias Tahmeel.Scheduler.Schema
  import Ecto.Query, only: [from: 2]

  def insert(opts) do
    Repo.insert!(%Schema{state: opts[:state], worker: "#{opts[:worker]}"})
  end

  def fetch_available_workers do
    from(s in Schema,
      select: s.worker,
      where: s.state == "available",
      update: [set: [state: "executing"]]
    )
    |> Repo.update_all([])
    |> case do
      {0, nil} -> []
      {_, workers} -> workers
    end
  end
end
