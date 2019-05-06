defmodule Probex.Application do
  @moduledoc false

  use Application

  def start(_type, _opts) do
    Supervisor.start_link([Probex.Registry],
      strategy: :one_for_one,
      name: Probex.Supervisor
    )
  end
end
