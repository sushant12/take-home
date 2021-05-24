defmodule Tahmeel.Scheduler.Config do
  @moduledoc """
  The Config struct that validates the scheduler state.
  """
  defstruct cron: []

  def new(opts) when is_list(opts) do
    Enum.each(opts, &validate_opt!/1)

    struct!(__MODULE__, opts)
  end

  defp validate_opt!({:cron, cron}) do
    Enum.each(cron, &validate_worker!/1)
  end

  defp validate_worker!({expr, worker}) when is_binary(expr) do
    unless Code.ensure_loaded?(worker) and function_exported?(worker, :run, 0) do
      raise """
      Unable to load: #{inspect(worker)}.
      Either you have missed to add `run/0` in #{inspect(worker)} or misspelled the module name
      """
    end
  end
end
