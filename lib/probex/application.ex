defmodule Probex.Application do
  @moduledoc false

  use Application

  def start(_type, _opts) do
    Probex.Registry.start_link()
  end
end
