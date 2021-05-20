defmodule Tahmeel.Scheduler.Executor do
  use GenServer

  alias Tahmeel.Scheduler.Notifier

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl true
  def init(opts) do
    :ok = Notifier.listen(self(), "schedule_job_insert")
    {:ok, opts}
  end

  @impl true
  def handle_info({:notification, _channel, _msg}, state) do
    Task.Supervisor.async_nolink(Tahmeel.TaskSchedulerSupervisor, fn ->
      Tahmeel.Workers.DemoWorker.run()
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
