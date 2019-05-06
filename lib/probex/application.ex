defmodule Probex.Application do
  @moduledoc false

  use Application

  @spec start(any(), any()) :: :ignore | {:error, any()} | {:ok, pid()}
  def start(_type, _opts) do
    Probex.Registry.start_link()
  end
end
