defmodule Tahmeel.WorkerSupervisor do
  use DynamicSupervisor

  @name __MODULE__

  alias Tahmeel.WorkerServer

  # def start_link(_args) do
  #   Supervisor.start_link(@name, nil, name: @name)
  # end

  # @impl true
  # def init(nil) do
  #   children = [
  #     {Tahmeel.WorkerServer, Application.get_env(:tahmeel, :periodic_jobs)}
  #   ]

  #   Supervisor.init(children, strategy: :one_for_one)
  # end

  def start_link(_arg) do
    DynamicSupervisor.start_link(@name, nil, name: @name)
  end

  @impl true
  def init(nil) do
    # jobs = Application.get_env(:tahmeel, :periodic_jobs)
    # Enum.each(jobs, &start_worker/1)
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def start_worker(worker) do
    child_spec = %{
      id: WorkerServer,
      start: {WorkerServer, :start_link, [worker]},
      restart: :transient
    }

    DynamicSupervisor.start_child(@name, child_spec)
  end
end
