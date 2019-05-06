defmodule Probex.Supervisor do
  @moduledoc false

  use Supervisor

  @spec start_link(keyword()) :: :ignore | {:error, any()} | {:ok, pid()}
  def start_link(opts) do
    config = config_opts(opts)

    with {:ok, true} <- ensure_started(),
         {:ok, true} <- ensure_unused(config.name),
         do: Supervisor.start_link(__MODULE__, config)
  end

  @impl true
  def init(config) do
    Supervisor.init(
      [
        {Probex.Probe.Supervisor, config.name},
        {Plug.Cowboy,
         scheme: config.scheme,
         plug: {Probex.Plug, config.name},
         options: [
           port: config.port,
           timeout: config.timeout,
           transport_options: [num_acceptors: 5]
         ]}
      ],
      strategy: :rest_for_one
    )
  end

  defp config_opts(opts) do
    opts
    |> Keyword.put_new(:port, 9_000)
    |> Keyword.put_new(:scheme, :http)
    |> Keyword.put_new(:timeout, 5_000)
    |> Enum.into(%{})
  end

  defp ensure_started() do
    if Probex.Registry.started?() do
      {:ok, true}
    else
      {:error, false}
    end
  end

  defp ensure_unused(name) do
    case Registry.lookup(Registry.Probex, name) do
      [] -> {:ok, true}
      [{pid, _}] -> {:error, {:already_started, pid}}
    end
  end
end
