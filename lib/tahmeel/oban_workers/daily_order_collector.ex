defmodule Tahmeel.ObanWorkers.DailyOrderCollector do
  @moduledoc """
  This module defines the Oban worker for gathering orders of the day.
  """

  use Oban.Worker, queue: :periodic

  alias Tahmeel.Deliveries

  @impl Oban.Worker
  def perform(_) do
    Deliveries.get_packages_to_be_delivered()
    |> Deliveries.gather_packages()
    |> Deliveries.save_bulk_order()

    :ok
  end
end
