defmodule LineBot.Webhook do
  use Plug.Router
  require Logger

  @moduledoc """
  This module is a `Plug` that handles incoming events from the Line server, and forwards
  them to your `LineBot` callback.

  It is recommended that you set up your own `Plug.Router`, and forward requests to the
  webhook URL to this plug, like this:

      forward "/bot", to: LineBot.Webhook, callback: YourCallbackModule

  This plug will read, validate, and parse the request body, so it must not appear
  in the same pipeline as other plugs such as `Plug.Parsers` that also read the request body.

  Note: The _verify_ button in the Developer Center when saving the webhook URL sends
  dummy data. This module replies to that request directly, rather than forwarding the
  request to your callback.

  ## Skipping Validation
  By default, requests are validated against the [X-Line-Signature](https://developers.line.biz/en/reference/messaging-api/#signature-validation) header. If the signature cannot be validated, a `403 Forbidden` response is returned.

  During development, it may be convenient to temporarily disable this behaviour. This can be achieved via configuration by setting `:skip_validation` to `true`.

      config :line_bot, skip_validation: true
  """

  plug :check_not_already_parsed
  plug LineBot.BodyReaderPlug
  plug LineBot.ValidatorPlug

  plug Plug.Parsers,
    parsers: [:json],
    json_decoder: Jason,
    body_reader: {LineBot.BodyReaderPlug, :read_cached_body, []}

  plug LineBot.RequestLoggerPlug, level: :debug

  plug :match
  plug :put_callback, builder_opts()
  plug :dispatch

  post "/", do: dispatch_events(conn)
  match "/", do: send_resp(conn, :method_not_allowed, "")
  match _, do: send_resp(conn, :not_found, "")

  @impl true
  @doc """
  Called when this plug is initialized. Expects an implementation of `LineBot` to be
  passed as the `:callback` option.
  """
  def init(opts) do
    case Keyword.fetch(opts, :callback) do
      {:ok, callback} -> callback
      :error -> raise "Must provide callback module: LineBot.Webhook, callback: YourModule"
    end
  end

  defp dispatch_events(
         %Plug.Conn{
           body_params: %{
             "events" => [%{"source" => %{"userId" => "Udeadbeefdeadbeefdeadbeefdeadbeef"}} | _]
           }
         } = conn
       ) do
    Logger.debug("handled webhoook verify request")
    send_resp(conn, :ok, "")
  end

  defp dispatch_events(
         %Plug.Conn{
           private: %{line_bot_callback: callback},
           body_params: %{"destination" => destination, "events" => events}
         } = conn
       ) do
    Task.Supervisor.start_child(LineBot.TaskSupervisor, fn ->
      LineBot.Dispatcher.dispatch_events(events, destination, callback)
    end)

    send_resp(conn, :ok, "")
  end

  defp dispatch_events(%Plug.Conn{private: %{line_bot_raw_body: request}} = conn) do
    Logger.warn("Unrecognised request: #{request}")
    send_resp(conn, :bad_request, "Unrecognised request")
  end

  defp check_not_already_parsed(%Plug.Conn{body_params: %Plug.Conn.Unfetched{}} = conn, _opts) do
    conn
  end

  defp check_not_already_parsed(conn, _opts) do
    Logger.error("Request must not be parsed by Plug.Parsers before reaching LineBot.Webhook")

    conn
    |> send_resp(:internal_server_error, "Body parsed before reaching Line Bot Webhook")
    |> halt()
  end

  defp put_callback(conn, callback), do: put_private(conn, :line_bot_callback, callback)
end
