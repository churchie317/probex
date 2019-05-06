defmodule Probex.Plug do
  def init(opts), do: opts

  @spec call(Plug.Conn.t(), any()) :: Plug.Conn.t()
  def call(conn, opts) do
    Probex.Router.call(conn, opts)
  end
end
