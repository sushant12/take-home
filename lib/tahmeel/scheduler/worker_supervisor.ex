defmodule Tahmeel.Scheduler.WorkerSupervisor do
  use Supervisor
  @name __MODULE__

  alias Tahmeel.Scheduler.Config

  def start_link(_args) do
    Supervisor.start_link(@name, nil, name: @name)
  end

  @impl true
  def init(nil) do
    config = Config.new(Application.get_env(:tahmeel, Scheduler))

    children = [
      {Task.Supervisor, name: Tahmeel.TaskSchedulerSupervisor},
      Tahmeel.Scheduler.Notifier,
      {Tahmeel.Scheduler.Cron, [config]},
      Tahmeel.Scheduler.Executor
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
