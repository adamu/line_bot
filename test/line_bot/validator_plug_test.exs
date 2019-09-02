defmodule LineBot.ValidatorPlugTest do
  use ExUnit.Case
  use Plug.Test
  alias LineBot.ValidatorPlug

  describe "init" do
    test "init just returns its arguments" do
      assert :foo == ValidatorPlug.init(:foo)
      assert ["bar"] == ValidatorPlug.init(["bar"])
      assert %{"key" => "value"} == ValidatorPlug.init(%{"key" => "value"})
    end
  end

  describe "call" do
    setup do
      Application.put_env(:line_bot, :client_secret, "dummy key")
    end

    test "fails if client_secret is not in env" do
      Application.delete_env(:line_bot, :client_secret)
      assert %ArgumentError{} = catch_error(ValidatorPlug.call(conn(:get, "/"), nil))
    end

    test "returns conn unaltered if skip_validation is set" do
      Application.put_env(:line_bot, :skip_validation, true)
      conn = conn(:get, "/")
      assert conn == ValidatorPlug.call(conn, nil)
      Application.delete_env(:line_bot, :skip_validation)
    end

    test "rejects requests with no X-Line-Signature header" do
      conn = conn(:post, "/") |> put_private(:line_bot_raw_body, "body")
      assert %Plug.Conn{status: 403, halted: true} = ValidatorPlug.call(conn, nil)
    end

    test "rejects requests with no body" do
      conn = conn(:post, "/") |> put_req_header("x-line-signature", "foo")
      assert %Plug.Conn{status: 403, halted: true} = ValidatorPlug.call(conn, nil)
    end

    test "rejects requests when the signature is invalid" do
      conn =
        conn(:post, "/")
        |> put_req_header("x-line-signature", "foo")
        |> put_private(:line_bot_raw_body, "body")

      assert %Plug.Conn{status: 403, halted: true} = ValidatorPlug.call(conn, nil)
    end

    test "passes requests when the signature is valid" do
      conn =
        conn(:post, "/")
        |> put_req_header("x-line-signature", "tzyYOZaQ8aI4GIwXQyDcTmuVRPB8lcKvLJ5cM++Nhjc=")
        |> put_private(:line_bot_raw_body, "body")

      assert conn == ValidatorPlug.call(conn, nil)
    end
  end
end
