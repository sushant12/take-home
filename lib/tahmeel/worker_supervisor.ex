defmodule Tahmeel.WorkerSupervisor do
  use Supervisor

  @name __MODULE__

  def start_link(_args) do
    Supervisor.start_link(@name, nil, name: @name)
  end

  @impl true
  def init(nil) do
    children = [
      {Tahmeel.WorkerServer, Application.get_env(:tahmeel, :periodic_jobs)}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
