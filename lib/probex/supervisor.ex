defmodule Probex.Supervisor do
  @moduledoc false

  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, opts)
  end

  @impl true
  def init(opts) do
    config = config_opts(opts)

    children = [
      {Probex.ProbeServer, config.name},
      {Plug.Cowboy,
       scheme: config.scheme,
       plug: {Probex.Plug, config.name},
       options: [
         port: config.port,
         timeout: config.timeout,
         transport_options: [num_acceptors: 5]
       ]}
    ]

    Supervisor.init(children, strategy: :rest_for_one)
  end

  defp config_opts(opts) do
    opts
    |> Keyword.put_new(:port, 9_000)
    |> Keyword.put_new(:scheme, :http)
    |> Keyword.put_new(:timeout, 5_000)
    |> Enum.into(%{})
  end
end
