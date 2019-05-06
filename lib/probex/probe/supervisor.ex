defmodule Probex.Probe.Supervisor do
  @moduledoc false

  use Supervisor

  alias Probex.Probe

  def start_link(name) do
    Supervisor.start_link(__MODULE__, name)
  end

  def init(name) do
    children = [{Probe.Stash, name}, {Probe.Server, name}]
    Supervisor.init(children, strategy: :one_for_one)
  end
end
