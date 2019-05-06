defmodule Probex.Probe.Server do
  @moduledoc false

  use GenServer

  alias Probex.Probe

  def ready?(name) do
    name
    |> Probex.Registry.via_tuple_from("_server")
    |> GenServer.call(:get_ready_state)
  end

  def live?(name) do
    name
    |> Probex.Registry.via_tuple_from("_server")
    |> GenServer.call(:get_live_state)
  end

  @spec start_link(atom()) :: :ignore | {:error, any()} | {:ok, pid()}
  def start_link(name) do
    GenServer.start_link(__MODULE__, name, name: Probex.Registry.via_tuple_from(name, "_server"))
  end

  @impl true
  def init(name), do: {:ok, Probe.get_from(name)}

  @impl true
  def handle_call(:get_ready_state, _from, state), do: {:reply, state.ready?, state}
  def handle_call(:get_live_state, _from, state), do: {:reply, state.live?, state}

  @impl true
  def handle_cast(:unavailable, state), do: {:noreply, %{state | ready?: false}}
  def handle_cast(:ready, state), do: {:noreply, %{state | ready?: true}}
  def handle_cast(:dead, state), do: {:noreply, %{state | live?: false}}
  def handle_cast(:alive, state), do: {:noreply, %{state | live?: true}}

  @impl true
  def handle_continue(_continue, state), do: {:noreply, state}

  @impl true
  def handle_info(msg, state), do: IO.inspect(msg) && {:noreply, state}

  @impl true
  def terminate(_reason, probe), do: Probe.stash(probe)
end
