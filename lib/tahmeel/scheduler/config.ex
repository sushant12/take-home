defmodule Tahmeel.Scheduler.Config do
  @moduledoc """
  The Config struct that validates the scheduler state.
  """
  defstruct cron: []

  def new(opts) when is_list(opts) do
    Enum.each(opts, &validate_opt!/1)

    struct!(__MODULE__, cron: opts)
  end

  defp validate_opt!({expr, worker}) when is_binary(expr) do
    unless Code.ensure_loaded?(worker) and function_exported?(worker, :run, 0) do
      raise "Worker not found: #{inspect(worker)}"
    end
  end
end
