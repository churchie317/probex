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
    GenServer.cast(name, :ready)
  end

  def signal_unavailable(name) do
    GenServer.cast(name, :unavailable)
  end

  def child_spec(opts) do
    %{
      id: Probex,
      start: {Probex.Supervisor, :start_link, [opts]}
    }
  end
end
