defmodule LineBotSample.Router do
  use Plug.Router
  use Plug.ErrorHandler
  require Logger

  plug Plug.Logger

  plug :match
  plug :dispatch

  forward "/bot", to: LineBot.Webhook, callback: LineBotSample

  get "/" do
    send_resp(conn, :ok, "Server is alive.")
  end

  match "/" do
    send_resp(conn, :method_not_allowed, "")
  end

  match _ do
    send_resp(conn, :not_found, "")
  end

  def handle_errors(conn, %{kind: :error, reason: reason, stack: _stack}) do
    message = Exception.message(reason)
    Logger.error(message)
    send_resp(conn, conn.status, message)
  end

  def handle_errors(conn, _) do
    send_resp(conn, conn.status, "Server Error")
  end
end
