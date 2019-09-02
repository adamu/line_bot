defmodule LineBot.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    with {:ok, client_id} when not is_nil(client_id) and client_id != "" <-
           Application.fetch_env(:line_bot, :client_id),
         {:ok, client_secret} when not is_nil(client_secret) and client_secret != "" <-
           Application.fetch_env(:line_bot, :client_secret) do
      children = [
        LineBot.TokenServer,
        LineBot.APIClient,
        {Task.Supervisor, name: LineBot.TaskSupervisor}
      ]

      opts = [strategy: :one_for_one, name: LineBot.Supervisor]
      Supervisor.start_link(children, opts)
    else
      error when error in [:error, {:ok, nil}, {:ok, ""}] ->
        {:error, "Not configured. Set config :line_bot, client_id: ..., client_secret: ..."}
    end
  end
end
