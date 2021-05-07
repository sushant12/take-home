defmodule Tahmeel.WorkerServer do
  use GenServer

  @name __MODULE__

  def start_link({_expr, worker} = args) do
    GenServer.start_link(@name, args, name: worker)
  end

  @impl true
  def init(args) do
    elem(args, 0) |> schedule_work()
    {:ok, args}
  end

  @impl true
  def handle_info(:run_task, state) do
    maybe_run_jobs(state)
    elem(state, 0) |> schedule_work()
    {:noreply, state}
  end

  defp maybe_run_jobs({_expr, worker}) do
    Task.start(fn -> apply(worker, :run, []) end)
  end

  defp schedule_work(cron_expr) do
    ms =
      Crontab.CronExpression.Parser.parse!(cron_expr)
      |> Crontab.Scheduler.get_next_run_date!()
      |> DateTime.from_naive!("Etc/UTC")
      |> DateTime.diff(DateTime.utc_now(), :millisecond)

    Process.send_after(self(), :run_task, ms)
  end
end
