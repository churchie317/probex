defmodule Probex.Registry do
  @moduledoc false

  use Supervisor

  @registry_name Registry.Probex

  @doc """
  Returns the registered name of the Probex process registry.
  """
  @spec name() :: Registry.Probex
  def name() do
    @registry_name
  end

  @doc """
  Checks whether the Probex Registry process is started.
  """
  @spec started?() :: boolean()
  def started?() do
    case Process.whereis(@registry_name) do
      pid when is_pid(pid) -> true
      _ -> false
    end
  end

  @doc """
  Returns the via tuple for a given process name on the Probex Registry.
  """
  @spec via_tuple_from(any()) :: {:via, Registry, {atom(), String.t()}}
  def via_tuple_from(process_name, suffix \\ "") do
    {:via, Registry, {@registry_name, to_string(process_name) <> suffix}}
  end

  @doc """
  Starts a Probex Registry process and links it to calling process.
  """
  def start_link() do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  @impl true
  def init(_) do
    Supervisor.init([{Registry, keys: :unique, name: @registry_name}], strategy: :one_for_one)
  end
end
