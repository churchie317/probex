defmodule Probex.ProbeServer do
  use GenServer

  alias Probex.ProbeServer

  defmodule State do
    defstruct ready?: false, live?: false
  end

  def ready?(name) do
    GenServer.call(name, :get_ready_state)
  end

  def live?(name) do
    GenServer.call(name, :get_live_state)
  end

  def start_link(name) do
    GenServer.start_link(__MODULE__, nil, name: name)
  end

  @impl true
  def init(_) do
    {:ok, %ProbeServer.State{}}
  end

  @impl true
  def handle_call(:get_ready_state, _from, state) do
    {:reply, state.ready?, state}
  end

  @impl true
  def handle_call(:get_live_state, _from, state) do
    {:reply, state.live?, state}
  end

  @impl true
  def handle_cast(:unavailable, state) do
    {:noreply, %{state | ready?: false}}
  end

  @impl true
  def handle_cast(:ready, state) do
    {:noreply, %{state | ready?: true}}
  end

  @impl true
  def handle_cast(:dead, state) do
    {:noreply, %{state | live?: false}}
  end

  @impl true
  def handle_cast(:alive, state) do
    {:noreply, %{state | live?: true}}
  end

  @impl true
  def handle_continue(_continue, state) do
    {:noreply, state}
  end

  @impl true
  def handle_info(_msg, state) do
    {:noreply, state}
  end
end
