defmodule Tahmeel.Scheduler.Cron do
  @moduledoc """

  """
  use GenServer

  alias Tahmeel.Scheduler.Cron.Expression
  alias Tahmeel.Scheduler.Repo

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl true
  def init([opts]) do
    opts =
      opts
      |> Map.get(:cron)
      |> parse_crontab()

    {:ok, opts, {:continue, :start}}
  end

  @impl true
  def handle_continue(:start, state) do
    Process.send_after(self(), :evaluate, 60_000)
    {:noreply, state}
  end

  @impl true
  def handle_info(:evaluate, state) do
    handle_continue(:start, state)

    for {expr, worker} <- state, Expression.now?(expr, DateTime.utc_now()) do
      Repo.insert(state: "running", worker: worker)
    end

    {:noreply, state}
  end

  defp parse_crontab(crontab) do
    crontab
    |> Enum.map(fn {expr, worker} ->
      {Expression.parse!(expr), worker}
    end)
  end
end
