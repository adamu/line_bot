Mox.defmock(MockAPIClient, for: HTTPoison.Base)
Mox.defmock(MockTokenServer, for: LineBot.TokenServer.Behaviour)

defmodule LineBot.TestHelpers do
  defmacro test_get_with_status(function, uri, args, params, status, status_atom) do
    quote do
      test "when get response is #{unquote(status)}" do
        expect(MockAPIClient, :get, fn unquote(uri), [], params: unquote(params) ->
          {:ok, %{status_code: unquote(status), body: "body"}}
        end)

        assert {unquote(status_atom), "body"} == apply(LineBot, unquote(function), unquote(args))
      end
    end
  end

  defmacro test_get_for(function, uri, args, params) do
    quote do
      describe Atom.to_string(unquote(function)) do
        test_get_with_status(
          unquote(function),
          unquote(uri),
          unquote(args),
          unquote(params),
          200,
          :ok
        )

        test_get_with_status(
          unquote(function),
          unquote(uri),
          unquote(args),
          unquote(params),
          401,
          :unauthorized
        )

        test_get_with_status(
          unquote(function),
          unquote(uri),
          unquote(args),
          unquote(params),
          403,
          :forbidden
        )

        test_get_with_status(
          unquote(function),
          unquote(uri),
          unquote(args),
          unquote(params),
          404,
          :not_found
        )

        test_get_with_status(
          unquote(function),
          unquote(uri),
          unquote(args),
          unquote(params),
          429,
          :too_many_requests
        )

        test_get_with_status(
          unquote(function),
          unquote(uri),
          unquote(args),
          unquote(params),
          500,
          :server_error
        )

        test "when error occurs during post" do
          error = %HTTPoison.Error{reason: "test error"}

          expect(MockAPIClient, :get, fn unquote(uri), [], params: unquote(params) ->
            {:error, error}
          end)

          assert {:error, error} == apply(LineBot, unquote(function), unquote(args))
        end
      end
    end
  end

  defmacro expect_post_status(uri, status) do
    quote do
      expect(MockAPIClient, :post, fn unquote(uri), data ->
        {:ok, %{status_code: unquote(status), body: data}}
      end)
    end
  end

  defmacro test_post_msg_with_status(function, uri, to, status, status_atom) do
    quote do
      test "when post response is #{unquote(status)}", %{data: data} do
        expect_post_status(unquote(uri), unquote(status))
        args = [["message"], "disabled"]
        args = if unquote(to), do: [unquote(to) | args], else: args
        assert {unquote(status_atom), data} == apply(LineBot, unquote(function), args)
      end
    end
  end

  defmacro test_post_msg(function, uri, to, data) do
    quote do
      describe Atom.to_string(unquote(function)) do
        setup do
          %{data: unquote(data)}
        end

        test_post_msg_with_status(unquote(function), unquote(uri), unquote(to), 200, :ok)

        test_post_msg_with_status(
          unquote(function),
          unquote(uri),
          unquote(to),
          401,
          :unauthorized
        )

        test_post_msg_with_status(unquote(function), unquote(uri), unquote(to), 403, :forbidden)
        test_post_msg_with_status(unquote(function), unquote(uri), unquote(to), 404, :not_found)

        test_post_msg_with_status(
          unquote(function),
          unquote(uri),
          unquote(to),
          429,
          :too_many_requests
        )

        test_post_msg_with_status(
          unquote(function),
          unquote(uri),
          unquote(to),
          500,
          :server_error
        )

        test "when error occurs during post" do
          error = %HTTPoison.Error{reason: "test error"}
          expect(MockAPIClient, :post, fn unquote(uri), _data -> {:error, error} end)

          args = [["message"], "disabled"]
          args = if unquote(to), do: [unquote(to) | args], else: args
          assert {:error, error} == apply(LineBot, unquote(function), args)
        end

        test "notification_disabled defaults to false" do
          expect(MockAPIClient, :post, fn unquote(uri), data ->
            {:ok, %{status_code: 200, body: data}}
          end)

          args = [["message"]]
          args = if unquote(to), do: [unquote(to) | args], else: args

          assert {:ok, %{"notificationDisabled" => false}} =
                   apply(LineBot, unquote(function), args)

          expect(MockAPIClient, :post, fn unquote(uri), data ->
            {:ok, %{status_code: 200, body: data}}
          end)

          args = [["message"], true]
          args = if unquote(to), do: [unquote(to) | args], else: args

          assert {:ok, %{"notificationDisabled" => true}} =
                   apply(LineBot, unquote(function), args)
        end

        test "single message is converted to single-element list" do
          expect(MockAPIClient, :post, fn unquote(uri), data ->
            {:ok, %{status_code: 200, body: data}}
          end)

          args = ["message"]
          args = if unquote(to), do: [unquote(to) | args], else: args

          assert {:ok, %{"messages" => ["message"]}} = apply(LineBot, unquote(function), args)
        end
      end
    end
  end

  defmacro test_post_uri_with_status(function, uri, arg, status, status_atom) do
    quote do
      test "when post response is #{unquote(status)}" do
        data = %{}
        expect_post_status(unquote(uri), unquote(status))
        assert {unquote(status_atom), data} == apply(LineBot, unquote(function), [unquote(arg)])
      end
    end
  end

  # TODO remove this duplication by refactoring the macro to test try_post behaviour,
  # and extracting the surrouding logic
  defmacro test_post_uri(function, uri, arg) do
    quote do
      describe Atom.to_string(unquote(function)) do
        test_post_uri_with_status(unquote(function), unquote(uri), unquote(arg), 200, :ok)

        test_post_uri_with_status(
          unquote(function),
          unquote(uri),
          unquote(arg),
          401,
          :unauthorized
        )

        test_post_uri_with_status(unquote(function), unquote(uri), unquote(arg), 403, :forbidden)
        test_post_uri_with_status(unquote(function), unquote(uri), unquote(arg), 404, :not_found)

        test_post_uri_with_status(
          unquote(function),
          unquote(uri),
          unquote(arg),
          429,
          :too_many_requests
        )

        test_post_uri_with_status(
          unquote(function),
          unquote(uri),
          unquote(arg),
          500,
          :server_error
        )

        test "when error occurs during post" do
          error = %HTTPoison.Error{reason: "test error"}
          expect(MockAPIClient, :post, fn unquote(uri), _data -> {:error, error} end)
          assert {:error, error} == apply(LineBot, unquote(function), [unquote(arg)])
        end
      end
    end
  end
end

ExUnit.start()
