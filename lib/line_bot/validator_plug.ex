defmodule LineBot.ValidatorPlug do
  import Plug.Conn
  require Logger

  @moduledoc false
  @behaviour Plug

  @impl true
  def init(opts), do: opts

  @impl true
  def call(conn, _opts) do
    client_secret = Application.fetch_env!(:line_bot, :client_secret)
    skip_validation = Application.get_env(:line_bot, :skip_validation, false)

    validate(conn, client_secret, skip_validation: skip_validation)
  end

  defp validate(conn, _client_secret, skip_validation: true) do
    Logger.warn("Skipping signature validation because :skip_validation is enabled.")
    conn
  end

  defp validate(conn, client_secret, skip_validation: false) do
    with [sig] <- get_req_header(conn, "x-line-signature"),
         body when not is_nil(body) <- conn.private[:line_bot_raw_body] do
      expected_sig =
        :crypto.hmac(:sha256, client_secret, body)
        |> Base.encode64()

      if sig === expected_sig do
        conn
      else
        Logger.warn("Signature was invalid. Rejecting. Sig: #{sig}")
        forbidden(conn)
      end
    else
      _ ->
        Logger.warn("Failed to validate signature. Signature header or body missing?")
        forbidden(conn)
    end
  end

  defp forbidden(conn) do
    conn
    |> send_resp(:forbidden, "Signature Invalid")
    |> halt
  end

  @doc """
  A helper for local debugging. Produces a valid signature for the supplied `body`,
  which can be used in the `X-Line-Signature` header.
  """
  def sign(body) do
    :crypto.hmac(:sha256, Application.get_env(:line_bot, :client_secret), body) |> Base.encode64()
  end
end
