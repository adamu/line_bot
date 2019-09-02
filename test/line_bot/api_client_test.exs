defmodule LineBot.APIClientTest do
  use ExUnit.Case
  import Mox
  alias LineBot.APIClient

  describe "Failure counter server" do
    test "initialises to 0" do
      assert APIClient.init(nil) == {:ok, 0}
    end

    test "get_and_inc_auth_fail fetches and increments count" do
      assert APIClient.handle_call(:get_and_inc_auth_fail, nil, 1) == {:reply, 1, 2}
    end

    test "reset resets the auth count" do
      assert APIClient.handle_call(:reset, nil, 123_123) == {:reply, :ok, 0}
    end
  end

  describe "HTTPoison.Base" do
    test "process_request_url adds prefix" do
      assert "https://api.line.me/v2/bot/foo" == APIClient.process_request_url("foo")
    end

    test "process_response passes through non-json responses" do
      response = %HTTPoison.Response{headers: [], body: "opaque"}
      assert response == APIClient.process_response(response)
    end

    test "process_repsonse decodes json responses" do
      content_type = {"content-type", "application/json"}
      response = %HTTPoison.Response{headers: [content_type], body: ~S'{"foo":"bar"}'}
      assert %{"foo" => "bar"} == APIClient.process_response(response).body
    end

    test "process_request_headers adds auth header from token server" do
      expect(MockTokenServer, :get_token, fn -> "dummy_token" end)
      expect(MockTokenServer, :get_token, fn -> "changed_token" end)

      assert [{"Authorization", "Bearer dummy_token"}] == APIClient.process_request_headers([])

      assert [{"Authorization", "Bearer changed_token"}, {"other", "header"}] ==
               APIClient.process_request_headers([{"other", "header"}])
    end

    # TODO these call super. Not sure how to test them without calling HTTPoison.
    # test "post adds json header and encodes"
    # test "post! adds json header and encodes"

    # TODO Test failure counter with global state?
    # What we really want to do here is start up an independent one for this test
    # can check the state against that. However, current code hardwires the process name.
    # Can we just test against the global object?
    # setup do
    # start_supervised(APIClient)
    # :ok
    # end
    # request
    # 200 => {ok, response}
    # 401 when < 3, purges token server and tries again
    # 401 when >= 3, {:ok, repsonse}
    # other => other
  end
end
