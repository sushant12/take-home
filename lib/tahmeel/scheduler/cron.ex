defmodule Tahmeel.Scheduler.Cron do
  @moduledoc """

  """
  use GenServer

  alias Tahmeel.Scheduler.Cron.Expression

  alias Tahmeel.Scheduler.Repo

  defmodule State do
    defstruct conf: nil, crontab: []
  end

  def start_link(conf) do
    GenServer.start_link(__MODULE__, conf, name: __MODULE__)
  end

  @impl true
  def init([conf]) do
    crontab = conf |> parse_crontab()
    state = struct!(Tahmeel.Scheduler.Cron.State, conf: conf, crontab: crontab)

    {:ok, state, {:continue, :schedule}}
  end

  @impl true
  def handle_continue(:schedule, state) do
    Process.send_after(self(), :evaluate, 59_000)
    {:noreply, state}
  end

  @impl true
  def handle_info(:evaluate, state) do
    handle_continue(:schedule, state)

    for {expr, worker} <- state.crontab, Expression.now?(expr, DateTime.utc_now()) do
      Repo.insert(state: "available", worker: worker)
    end

    {:noreply, state}
  end

  defp parse_crontab(conf) do
    conf
    |> Map.fetch!(:cron)
    |> Enum.map(fn {expr, worker} ->
      {Expression.parse!(expr), worker}
    end)
  end
end
