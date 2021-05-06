defmodule Tahmeel.Workers.DailyOrderCollector do
  @moduledoc """
  This module defines the worker for gathering orders of the day.
  """
  alias Tahmeel.Deliveries

  def run do
    Deliveries.get_packages_to_be_delivered()
    |> Deliveries.gather_packages()
  end
end
