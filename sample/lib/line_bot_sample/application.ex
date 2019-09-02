defmodule LineBotSample.Application do
  use Application
  require Logger

  @moduledoc false

  def start(_type, _args) do
    port = Application.get_env(:line_bot_sample, :port) || 4000

    children = [
      Plug.Cowboy.child_spec(scheme: :http, plug: LineBotSample.Router, options: [port: port])
    ]

    opts = [strategy: :one_for_one, name: LineBotSample.Supervisor]

    Logger.info("Starting bot server on port #{port}...")
    Supervisor.start_link(children, opts)
  end
end
