defmodule Probex.Probe do
  @moduledoc false

  alias Probex.Probe

  defstruct ready?: false, live?: true, name: nil

  @spec new(any()) :: Probex.Probe.t()
  def new(name) do
    %Probe{name: name}
  end

  def get_from(name) do
    name
    |> Probex.Registry.via_tuple_from("_stash")
    |> GenServer.call(:get_probe)
  end

  def stash(probe) do
    probe.name
    |> Probex.Registry.via_tuple_from("_stash")
    |> GenServer.cast({:set_probe, probe})
  end
end
