defmodule Tahmeel.Scheduler.Repo do
  alias Tahmeel.Repo
  alias Tahmeel.Scheduler.Schema

  def insert(opts) do
    Repo.insert!(%Schema{state: opts[:state], worker: "#{opts[:worker]}"})
  end
end
