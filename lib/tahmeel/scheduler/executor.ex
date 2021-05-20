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
  def handle_info({:notification, channel, msg}, state) do
    IO.inspect(channel, label: "channel")
    IO.inspect(msg, label: "msg")
    {:noreply, state}
  end
end
