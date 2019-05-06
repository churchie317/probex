defmodule Probex.Plug do
  @moduledoc false

  @spec init(atom()) :: atom()
  def init(opts), do: opts

  @spec call(Plug.Conn.t(), any()) :: Plug.Conn.t()
  def call(conn, opts) do
    Probex.Plug.Router.call(conn, opts)
  end
end
