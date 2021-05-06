defmodule Tahmeel.WorkerServer do
  use GenServer

  @name __MODULE__

  alias Tahmeel.Cron.Expression

  def start_link(args) do
    GenServer.start_link(@name, args, name: @name)
  end

  @impl true
  def init(args) do
    {:ok, args, {:continue, :start}}
  end

  @impl GenServer
  def handle_continue(:start, state) do
    handle_info(:work, state)
  end

  @impl true
  def handle_info(:work, state) do
    maybe_run_jobs(state)
    schedule_work()
    {:noreply, state}
  end

  defp maybe_run_jobs(state) do
    Enum.each(state, fn {expression, worker} ->
      expr = Expression.parse!(expression)
      Expression.now?(expr) and Task.start(fn -> apply(worker, :run, []) end)
    end)
  end

  defp schedule_work do
    Process.send_after(self(), :work, 1000)
  end
end
