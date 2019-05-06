defmodule Probex.Probe.Stash do
  @moduledoc false

  use GenServer

  alias Probex.Probe

  def start_link(name) do
    GenServer.start_link(__MODULE__, name, name: Probex.Registry.via_tuple_from(name, "_stash"))
  end

  @impl true
  def init(name) do
    {:ok, Probe.new(name)}
  end

  @impl true
  def handle_call(:get_probe, _from, probe) do
    {:reply, probe, probe}
  end

  @impl true
  def handle_cast({:set_probe, probe}, _state) do
    IO.inspect(probe)
    {:noreply, probe}
  end

  @impl true
  def handle_continue(_continue, probe) do
    {:noreply, probe}
  end

  @impl true
  def handle_info(_msg, probe) do
    {:noreply, probe}
  end
end
