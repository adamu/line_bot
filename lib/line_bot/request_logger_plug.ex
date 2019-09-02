defmodule LineBot.RequestLoggerPlug do
  @behaviour Plug
  @moduledoc false

  @impl true
  def init(opts), do: Keyword.get(opts, :level, :debug)

  @impl true
  def call(%Plug.Conn{private: %{line_bot_raw_body: request}} = conn, level) do
    Logger.bare_log(level, "Webhook Request: #{String.replace(request, ~r(\n\s*), "")}")
    conn
  end
end
