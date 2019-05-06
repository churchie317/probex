defmodule Probex.Plug.Router do
  use Plug.Router

  alias Probex.ProbeServer

  plug(:match)
  plug(:dispatch, builder_opts())

  get "/ready" do
    if ProbeServer.ready?(opts) do
      send_resp(conn, 200, "SERVICE_READY")
    else
      send_resp(conn, 503, "SERVICE_PENDING")
    end
  end

  get "/live" do
    if ProbeServer.live?(opts) do
      send_resp(conn, 200, "SERVICE_READY")
    else
      send_resp(conn, 503, "SERVICE_DOWN")
    end
  end
end
