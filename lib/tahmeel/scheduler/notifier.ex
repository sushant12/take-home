defmodule Tahmeel.Scheduler.Notifier do
  use GenServer

  alias Postgrex.Notifications

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def listen(server, channel) do
    GenServer.call(__MODULE__, {:listen, {server, channel}})
  end

  @impl true
  def init(_) do
    state = %{listeners: %{}, conn: nil}
    {:ok, state, {:continue, :start}}
  end

  @impl true
  def handle_continue(:start, state) do
    {:noreply, connect_and_listen(state)}
  end

  @impl true
  def handle_info({:notification, _, _, channel, payload}, state) do
    decoded_msg = Jason.decode!(payload)

    state[:listeners]
    |> Enum.each(fn {pid, _channel} ->
      send(pid, {:notification, channel, decoded_msg})
    end)

    {:noreply, state}
  end

  @impl true
  def handle_call({:listen, {server, channel}}, _, state) do
    state = %{state | listeners: %{server => channel}}
    {:reply, :ok, state}
  end

  defp connect_and_listen(state) do
    case Notifications.start_link(Tahmeel.Repo.config()) do
      {:ok, conn} ->
        Notifications.listen(conn, "schedule_job_insert")
        %{state | conn: conn}

      {:error, _error} ->
        state
    end
  end
end
