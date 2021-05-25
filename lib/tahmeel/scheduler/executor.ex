defmodule Tahmeel.Scheduler.Executor do
  use GenServer

  alias Tahmeel.Scheduler.Notifier
  alias Tahmeel.Scheduler.Repo

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  @impl true
  def init(_) do
    :ok = Notifier.listen(self(), "schedule_job_insert")
    {:ok, []}
  end

  @impl true
  def handle_info({:notification, _channel, _msg}, state) do
    Repo.fetch_available_workers()
    |> Enum.each(fn worker ->
      Task.Supervisor.async_nolink(Tahmeel.TaskSchedulerSupervisor, fn ->
        worker =
          worker
          |> String.split(".")
          |> Module.safe_concat()

        worker.run()
      end)
    end)

    {:noreply, state}
  end

  def handle_info({ref, _}, state) do
    Process.demonitor(ref, [:flush])
    {:noreply, state}
  end

  def handle_info({:DOWN, _, _, _, _}, state) do
    {:noreply, state}
  end
end
