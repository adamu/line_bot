defmodule LineBot.APIClient do
  use GenServer
  use HTTPoison.Base
  require Logger

  @token_server Application.get_env(:line_bot, :token_server, LineBot.TokenServer)

  @moduledoc """
  An implementation of `HTTPoison.Base` for making API calls to the Messaging API.

  ## API Client

  This module is for creating and sending HTTP requests manually. To use the documented messaging
  API endpoints, use the `LineBot` module, which calls the functions in this module.

  ## Implementation

  This module extends `HTTPoison.Base` with the following behaviour:

  * The `Authorization` header containing the bearer token is automatically added. The access
    token is retreived from `LineBot.TokenServer`.
  * URLs are automatically prefixed with `https://api.line.me/v2/bot/`. When making a request,
    only the path after this prefix is required.
  * JSON responses are automatically decoded.
  * POST requests are automatically encoded into JSON, and the appropriate  `Content-Type` header
    is added.
  * 401 Unauthorized errors are caught. When an unauthorized request is received, an attempt
    to retrieve a new access token is made by calling `LineBot.TokenServer.purge/0`. However,
    after three successive  unauthorized errors, further unauthorized responses are returned
    directly.
  """

  # GenServer
  ############

  @impl GenServer
  def init(_), do: {:ok, 0}

  @impl GenServer
  def handle_call(:get_and_inc_auth_fail, _from, count), do: {:reply, count, count + 1}

  @impl GenServer
  def handle_call(:reset, _from, _count), do: {:reply, :ok, 0}

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  # HTTPoison
  ############

  @impl HTTPoison.Base
  @doc "Prepends the request url with `https://api.line.me/v2/bot/`."
  def process_request_url(url), do: super("https://api.line.me/v2/bot/" <> url)

  @impl HTTPoison.Base
  @doc """
  Adds the OAuth Bearer token to the `Authorization` header.
  The token is retrieved by calling `LineBot.TokenServer.get_token/0`.

  Also adds the `User-Agent` header with a value of `line-botsdk-elixir/vX.X.X`.
  This follows the pattern of Line Bot libraries in other languages.
  """
  def process_request_headers(headers) do
    [
      {"Authorization", "Bearer #{@token_server.get_token()}"},
      {"User-Agent", "line-botsdk-elixir/v#{Application.spec(:line_bot, :vsn)}"}
      | super(headers)
    ]
  end

  @impl HTTPoison.Base
  @doc """
  If the reponse headers indidate that the response is JSON, the response body is
  automatically decoded.
  """
  def process_response(%{headers: headers, body: body} = response) do
    # TODO make this configurable
    Logger.debug("API Response: " <> inspect(response))

    case Enum.find(headers, &(String.downcase(elem(&1, 0)) == "content-type")) do
      {_, "application/json" <> _} -> put_in(response.body, Jason.decode!(body))
      _ -> super(response)
    end
  end

  @impl HTTPoison.Base
  @doc """
  Issues a POST request to the given url.
  The body is automatically encoded into JSON, and the `Content-Type` header is added.
  """
  def post(url, body, headers \\ []) do
    super(url, Jason.encode!(body), [{"Content-Type", "application/json"} | headers])
  end

  @impl HTTPoison.Base
  @doc """
  Issues a POST request to the given url.
  The body is automatically encoded into JSON, and the `Content-Type` header is added.
  """
  def post!(url, body, headers \\ []) do
    super(url, Jason.encode!(body), [{"Content-Type", "application/json"} | headers])
  end

  @impl HTTPoison.Base
  @doc """
  In addition to the `HTTPoison.request/5` behaviour, will automatically refresh the access
  token after an unauthorized request. Gives up after three subsequent unauthorized errors.
  """
  def request(method, url, body, headers, opts \\ []) do
    case super(method, url, body, headers, opts) do
      {:ok, %{status_code: 200} = response} ->
        {:via, Registry, {LineBot.Registry, "client"}}
        GenServer.call(__MODULE__, :reset)
        {:ok, response}

      {:ok, %{status_code: 401} = response} ->
        if GenServer.call(__MODULE__, :get_and_inc_auth_fail) < 3 do
          Logger.warn("Unauthorized. Purge token and try again.")
          @token_server.purge()
          request(method, url, body, headers, opts)
        else
          Logger.warn("Unauthorized after multiple attempts with different tokens. Giving up.")
          {:ok, response}
        end

      other ->
        other
    end
  end
end
