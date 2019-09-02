defmodule LineBot.BodyReaderPlug do
  import Plug.Conn

  @behaviour Plug
  @moduledoc false

  @impl true
  def init(_opts), do: nil

  @impl true
  def call(conn, _opts) do
    case Plug.Conn.read_body(conn) do
      {:ok, body, conn} ->
        put_private(conn, :line_bot_raw_body, body)

      {:more, _body, _conn} ->
        raise Plug.BadRequestError

      {:error, :timeout} ->
        raise Plug.TimeoutError

      {:error, _} ->
        raise Plug.BadRequestError
    end
  end

  def read_cached_body(conn, _opts), do: {:ok, conn.private.line_bot_raw_body, conn}
end