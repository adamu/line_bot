defmodule LineBot.BodyReaderPlugTest do
  use ExUnit.Case
  use Plug.Test
  alias LineBot.BodyReaderPlug

  test "call puts body into line_bot_raw_body private field" do
    conn = conn(:get, "/", "body")
    assert "body" == BodyReaderPlug.call(conn, []).private.line_bot_raw_body
  end

  test "body greater than :length is not supported" do
    conn = conn(:get, "/", "body")

    assert %Plug.BadRequestError{} =
             catch_error(BodyReaderPlug.call(conn, length: 1).private.line_bot_raw_body)
  end
end
