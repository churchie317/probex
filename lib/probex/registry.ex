defmodule Probex.Registry do
  @moduledoc false

  use Supervisor

  @registry_name :lightship_registry

  @doc """
  Returns the via tuple for a given process name on the Lightship Registry.
  """
  def name(process_name, suffix \\ "") do
    {:via, Registry, {@registry_name, process_name <> suffix}}
  end

  @doc """
  Starts a Lightship Registry process and links it to calling process.
  """
  def start_link(_) do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  @impl true
  def init(_) do
    Supervisor.init(
      [
        {Registry, keys: :unique, name: @registry_name}
      ],
      strategy: :one_for_one
    )
  end
end
