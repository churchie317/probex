defmodule Probex do
  @moduledoc """
  Documentation for Probex.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Probex.hello()
      :world

  """
  def signal_ready(name) do
    name
    |> Probex.Registry.via_tuple_from("_server")
    |> GenServer.cast(:ready)
  end

  def signal_pending(name) do
    name
    |> Probex.Registry.via_tuple_from("_server")
    |> GenServer.cast(:unavailable)
  end

  def signal_alive(name) do
    name
    |> Probex.Registry.via_tuple_from("_server")
    |> GenServer.cast(:alive)
  end

  def signal_unavailable(name) do
    name
    |> Probex.Registry.via_tuple_from("_server")
    |> GenServer.cast(:dead)
  end

  def child_spec(opts) do
    %{
      id: Probex,
      start: {Probex.Supervisor, :start_link, [opts]}
    }
  end
end
