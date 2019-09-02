defmodule LineBot.TokenServer do
  defmodule Behaviour do
    @moduledoc false
    @callback get_token() :: binary
    @callback revoke_token() :: term
    @callback purge() :: term
  end

  use GenServer
  @behaviour Behaviour
  require Logger

  @moduledoc """
  A GenServer that manages the [OAuth token](https://developers.line.biz/en/reference/messaging-api/#oauth)
  for Line API calls.

  This server is started automatically by the `:line_bot` application, and requires the
  `:client_id`, and `:client_secret` to have been configured.

  The current token is retrieved with `get_token/0`, which also fetches a new token from the auth
  server if the current one has expired (or has never been fetched).

  """

  ## Server

  @impl GenServer
  def init(_) do
    state = %{
      token: nil,
      expires_on: DateTime.utc_now(),
      client_id: Application.fetch_env!(:line_bot, :client_id),
      client_secret: Application.fetch_env!(:line_bot, :client_secret)
    }

    {:ok, state}
  end

  @impl GenServer
  def handle_call(:token, _from, state) do
    state =
      case DateTime.compare(state.expires_on, DateTime.utc_now()) do
        :gt -> state
        _ -> refresh_token(state)
      end

    {:reply, state.token, state}
  end

  @impl GenServer
  def handle_call(:revoke, from, state) do
    post_revoke_token(state.token)
    handle_call(:purge, from, state)
  end

  @impl GenServer
  def handle_call(:purge, _from, state) do
    {:reply, :ok, %{state | token: nil, expires_on: DateTime.utc_now()}}
  end

  defp refresh_token(state) do
    {token, expires_in} = post_request_token(state.client_id, state.client_secret)
    # Set the expiry 5 minutes earlier, to avoid edge cases
    expires_on = DateTime.add(DateTime.utc_now(), expires_in - 300, :second)
    Logger.info("Retrieved new access token that expires on #{expires_on}.")
    %{state | token: token, expires_on: expires_on}
  end

  @headers [{"Content-Type", "application/x-www-form-urlencoded"}]

  defp post_request_token(client_id, client_secret) do
    data = [
      grant_type: "client_credentials",
      client_id: client_id,
      client_secret: client_secret
    ]

    %{"access_token" => access_token, "expires_in" => expires_in} =
      "https://api.line.me/v2/oauth/accessToken"
      |> HTTPoison.post!({:form, data}, @headers)
      |> Map.get(:body)
      |> Jason.decode!()

    {access_token, expires_in}
  end

  defp post_revoke_token(access_token) do
    HTTPoison.post!(
      "https://api.line.me/v2/oauth/revoke",
      {:form, [access_token: access_token]},
      @headers
    )
  end

  ## Client

  @doc false
  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @doc """
  Gets the currently stored token. If the token has expired, a new token is retrieved.
  """
  @impl Behaviour
  def get_token() do
    GenServer.call(__MODULE__, :token)
  end

  @doc """
  Revokes the current access token. This revokes the token with the API server, so the token will
  become invalid and cannot be used elsewhere.

  A new token will be retrieved on the next call
  to `get_token/0`.
  """
  @impl Behaviour
  def revoke_token() do
    GenServer.call(__MODULE__, :revoke)
  end

  @doc """
  Purges the current access token. This only removes the token from this process' state, it does
  not revoke the token.

  A new token will be retrieved on the next call to `get_token/0`.
  To revoke the token, use `revoke_token/0`.
  """
  @impl Behaviour
  def purge() do
    GenServer.call(__MODULE__, :purge)
  end
end
