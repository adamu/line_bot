defmodule LineBot.TokenServerTest do
  use ExUnit.Case
  use Plug.Test
  import Mox
  alias LineBot.TokenServer

  @client_id 123_456
  @client_secret "test dummy secret"

  setup do
    %{
      state: %{
        token: "original token",
        expires_on: DateTime.utc_now(),
        client_id: @client_id,
        client_secret: @client_secret
      }
    }
  end

  describe "init" do
    setup do
      global_client_id = Application.fetch_env!(:line_bot, :client_id)
      global_client_secret = Application.fetch_env!(:line_bot, :client_id)

      Application.put_env(:line_bot, :client_id, @client_id)
      Application.put_env(:line_bot, :client_secret, @client_secret)

      on_exit(fn ->
        Application.put_env(:line_bot, :client_id, global_client_id)
        Application.put_env(:line_bot, :client_secret, global_client_secret)
      end)
    end

    test "sets access tokent to nil" do
      assert {:ok, %{token: nil}} = TokenServer.init(nil)
    end

    test "sets expiry time to now" do
      now = DateTime.utc_now()
      {:ok, %{expires_on: then}} = TokenServer.init(nil)
      assert DateTime.diff(now, then) <= 1
    end

    test "gets client credentials from application environment" do
      assert {:ok, %{client_id: @client_id, client_secret: @client_secret}} =
               TokenServer.init(nil)
    end
  end

  describe "handle_token" do
    test "when token is not expired, returns current token" do
      state = %{
        token: "original token",
        expires_on: DateTime.add(DateTime.utc_now(), 100_000, :second)
      }

      assert {:reply, "original token", %{token: "original token"}} =
               TokenServer.handle_call(:token, nil, state)
    end

    test "when token has expired, fetches and returns new token, and adds it to state", %{
      state: state
    } do
      data = [
        grant_type: "client_credentials",
        client_id: @client_id,
        client_secret: @client_secret
      ]

      expect(MockAPIClient, :post!, fn "https://api.line.me/v2/oauth/accessToken",
                                       {:form, ^data},
                                       [
                                         {"Content-Type", "application/x-www-form-urlencoded"},
                                         {"User-Agent", "line-botsdk-elixir/v" <> _}
                                       ] ->
        %{body: ~S'{"access_token":"new token", "expires_in":1000}'}
      end)

      assert {:reply, "new token", %{token: "new token", expires_on: expires_on}} =
               TokenServer.handle_call(:token, nil, state)

      assert DateTime.diff(DateTime.utc_now(), expires_on) <= 1
    end
  end

  describe "handle_purge" do
    test "sets token to nil and expiry to an expired date", %{state: state} do
      assert {:reply, :ok, %{token: nil, expires_on: expires_on}} =
               TokenServer.handle_call(:purge, nil, state)

      assert DateTime.diff(DateTime.utc_now(), expires_on) <= 0
    end
  end

  describe "handle_revoke" do
    test "calls purge API and sets token to nil and expiry to an expired date", %{state: state} do
      expect(MockAPIClient, :post!, fn "https://api.line.me/v2/oauth/revoke",
                                       {:form, [access_token: "original token"]},
                                       [
                                         {"Content-Type", "application/x-www-form-urlencoded"},
                                         {"User-Agent", "line-botsdk-elixir/v" <> _}
                                       ] ->
        :ok
      end)

      assert {:reply, :ok, %{token: nil, expires_on: expires_on}} =
               TokenServer.handle_call(:revoke, nil, state)

      assert DateTime.diff(DateTime.utc_now(), expires_on) <= 0
    end
  end
end
