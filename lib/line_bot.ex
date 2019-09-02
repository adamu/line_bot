defmodule LineBot do
  alias LineBot.EventInfo

  @api_client Application.get_env(:line_bot, :api_client, LineBot.APIClient)

  @moduledoc """
  A module for sending and receiving messages with the Line Messaging API.

  This module:
  * Provides functions for calling the various Line Messaging API endpoints.
  * Specifies a behaviour that defines event handlers which are called to handle
  [webhook event objects](https://developers.line.biz/en/reference/messaging-api/#webhook-event-objects)
  from the Messaging API.

  ## Callbacks
  If an event contains event-specific data, it is passed as the first argument to the event handler.
  Each callback is provided with a `t:LineBot.EventInfo.t/0` struct, which contains common metadata for
  each request. If available, a `reply_token` for use with the `send_reply/3`
  is included as the final argument.

  Unknown events are passed to `c:handle_other/4`.

  All of the callbacks are optional. If a callback is not implemented, the event will be ignored.
  """

  @doc """
  Called when a [Message event](https://developers.line.biz/en/reference/messaging-api/#message-event)
  is received.
  """
  @callback handle_message(message :: map, info :: EventInfo.t(), reply_token :: binary) :: any

  @doc """
  Called when a [Follow event](https://developers.line.biz/en/reference/messaging-api/#follow-event)
  is received.
  """
  @callback handle_follow(info :: EventInfo.t(), reply_token :: binary) :: any

  @doc """
  Called when an [Unfollow event](https://developers.line.biz/en/reference/messaging-api/#unfollow-event)
  is received.
  """
  @callback handle_unfollow(info :: EventInfo.t()) :: any

  @doc """
  Called when a [Join event](https://developers.line.biz/en/reference/messaging-api/#join-event)
  is received.
  """
  @callback handle_join(info :: EventInfo.t(), reply_token :: binary) :: any

  @doc """
  Called when a [Leave event](https://developers.line.biz/en/reference/messaging-api/#leave-event)
  is received.
  """
  @callback handle_leave(info :: EventInfo.t()) :: any

  @doc """
  Called when a [Member Joined event](https://developers.line.biz/en/reference/messaging-api/#member-joined-event)
  is received.
  """
  @callback handle_member_joined(
              members :: list,
              info :: EventInfo.t(),
              reply_token :: binary
            ) :: any

  @doc """
  Called when a [Member Left event](https://developers.line.biz/en/reference/messaging-api/#member-left-event)
  is received.
  """
  @callback handle_member_left(members :: list, info :: EventInfo.t()) :: any

  @doc """
  Called when a [Postback event](https://developers.line.biz/en/reference/messaging-api/#postback-event)
  is received.
  """
  @callback handle_postback(
              data :: any,
              info :: EventInfo.t(),
              reply_token :: binary
            ) :: any

  @doc """
  Called when a [Beacon event](https://developers.line.biz/en/reference/messaging-api/#beacon-event)
  is received.
  """
  @callback handle_beacon(
              data :: map,
              info :: EventInfo.t(),
              reply_token :: binary
            ) :: any

  @doc """
  Called when an [Account Link event](https://developers.line.biz/en/reference/messaging-api/#account-link-event)
  is received.
  """
  @callback handle_account_link(
              data :: map,
              info :: EventInfo.t(),
              reply_token :: binary
            ) :: any

  @doc """
  Called when a [LINE Things Scenario Execution event](https://developers.line.biz/en/reference/messaging-api/#scenario result)
  is received.
  """
  @callback handle_things(
              data :: map,
              info :: EventInfo.t(),
              reply_token :: binary
            ) :: any

  @doc """
  Called when an unknown even it received. The `type` contains the unknown event type, and the full event is passed as the `event` argument. If a reply token was not present in the event, `reply_token` will be `nil`.
  """
  @callback handle_other(
              type :: binary,
              event :: map,
              info :: EventInfo.t(),
              reply_token :: binary | nil
            ) :: any

  @optional_callbacks handle_message: 3,
                      handle_follow: 2,
                      handle_unfollow: 1,
                      handle_join: 2,
                      handle_leave: 1,
                      handle_member_joined: 3,
                      handle_member_left: 2,
                      handle_postback: 3,
                      handle_beacon: 3,
                      handle_account_link: 3,
                      handle_things: 3,
                      handle_other: 4

  defmacro __using__(_opts) do
    quote do
      @behaviour LineBot

      def handle_message(message, info, reply_token), do: :ok
      def handle_follow(info, reply_token), do: :ok
      def handle_unfollow(info), do: :ok
      def handle_join(info, reply_token), do: :ok
      def handle_leave(info), do: :ok
      def handle_member_joined(members, info, reply_token), do: :ok
      def handle_member_left(members, info), do: :ok
      def handle_postback(data, info, reply_token), do: :ok
      def handle_beacon(data, info, reply_token), do: :ok
      def handle_account_link(data, info, reply_token), do: :ok
      def handle_things(data, info, reply_token), do: :ok
      def handle_other(type, event, info, reply_token), do: :ok

      defoverridable LineBot
    end
  end

  @type api_response ::
          {:ok, map()}
          | {:unauthorized, map()}
          | {:forbidden, map()}
          | {:not_found, map()}
          | {:too_many_requests, map()}
          | {:server_error, map()}
          | {:error, HTTPoison.Error.t()}

  defp try_get(uri, params \\ []) do
    case @api_client.get(uri, [], params: params) do
      {:ok, %{status_code: 200, body: body}} -> {:ok, body}
      {:ok, %{status_code: 401, body: body}} -> {:unauthorized, body}
      {:ok, %{status_code: 403, body: body}} -> {:forbidden, body}
      {:ok, %{status_code: 404, body: body}} -> {:not_found, body}
      {:ok, %{status_code: 429, body: body}} -> {:too_many_requests, body}
      {:ok, %{status_code: 500, body: body}} -> {:server_error, body}
      {:error, %HTTPoison.Error{} = error} -> {:error, error}
    end
  end

  defp try_post(uri, data \\ %{}) do
    case @api_client.post(uri, data) do
      {:ok, %{status_code: 200, body: body}} -> {:ok, body}
      {:ok, %{status_code: 401, body: body}} -> {:unauthorized, body}
      {:ok, %{status_code: 403, body: body}} -> {:forbidden, body}
      {:ok, %{status_code: 404, body: body}} -> {:not_found, body}
      {:ok, %{status_code: 429, body: body}} -> {:too_many_requests, body}
      {:ok, %{status_code: 500, body: body}} -> {:server_error, body}
      {:error, %HTTPoison.Error{} = error} -> {:error, error}
    end
  end

  @doc """
  Sends one or more [reply messages](https://developers.line.biz/en/reference/messaging-api/#send-reply-message).
  """
  @spec send_reply(
          reply_token :: String.t(),
          messages :: [LineBot.Message.t()] | LineBot.Message.t(),
          notification_disabled :: boolean()
        ) :: api_response()
  def send_reply(reply_token, messages, notification_disabled \\ false)

  def send_reply(reply_token, messages, notification_disabled) when is_list(messages) do
    try_post("message/reply", %{
      "replyToken" => reply_token,
      "messages" => messages,
      "notificationDisabled" => notification_disabled
    })
  end

  def send_reply(to, message, notification_disabled),
    do: send_reply(to, [message], notification_disabled)

  @doc """
  Sends one or more [push messages](https://developers.line.biz/en/reference/messaging-api/#send-push-message).
  """
  @spec send_push(
          to :: String.t(),
          messages :: [LineBot.Message.t()] | LineBot.Message.t(),
          notification_disabled :: boolean()
        ) :: api_response()
  def send_push(to, messages, notification_disabled \\ false)

  def send_push(to, messages, notification_disabled) when is_list(messages) do
    try_post("message/push", %{
      "to" => to,
      "messages" => messages,
      "notificationDisabled" => notification_disabled
    })
  end

  def send_push(to, message, notification_disabled),
    do: send_push(to, [message], notification_disabled)

  @doc """
  Sends one or more [multicast messages](https://developers.line.biz/en/reference/messaging-api/#send-multicast-message).

  """
  @spec send_multicast(
          to :: [String.t()],
          messages :: [LineBot.Message.t()] | LineBot.Message.t(),
          notification_disabled :: boolean()
        ) :: api_response()
  def send_multicast(to, messages, notification_disabled \\ false)

  def send_multicast(to, messages, notification_disabled)
      when is_list(to) and is_list(messages) do
    try_post("message/multicast", %{
      "to" => to,
      "messages" => messages,
      "notificationDisabled" => notification_disabled
    })
  end

  def send_multicast(to, message, notification_disabled) when is_list(to) do
    send_multicast(to, [message], notification_disabled)
  end

  @doc """
  Sends one or more [broadcast messages](https://developers.line.biz/en/reference/messaging-api/#send-broadcast-message).
  """
  @spec send_broadcast(
          messages :: [LineBot.Message.t()] | LineBot.Message.t(),
          notification_disabled :: boolean()
        ) :: api_response()
  def send_broadcast(messages, notification_disabled \\ false)

  def send_broadcast(messages, notification_disabled) when is_list(messages) do
    try_post("message/broadcast", %{
      "messages" => messages,
      "notificationDisabled" => notification_disabled
    })
  end

  def send_broadcast(message, notification_disabled) do
    send_broadcast([message], notification_disabled)
  end

  @doc """
  Calls the [Get content](https://developers.line.biz/en/reference/messaging-api/#get-content) API.
  """
  @spec get_content(message_id :: binary()) :: HTTPoison.Response.t()
  def get_content(message_id), do: @api_client.get!("message/#{message_id}/content")

  @doc """
  Calls the [Get number of message deliveries](https://developers.line.biz/en/reference/messaging-api/#get-number-of-delivery-messages) API.
  """
  @spec get_quota(date :: String.t()) :: api_response()
  def get_quota(date), do: try_get("message/quota", date: date)

  @doc """
  Calls the [Get number of messages sent this month](https://developers.line.biz/en/reference/messaging-api/#get-consumption) API.
  """
  @spec get_quota_consumption() :: api_response()
  def get_quota_consumption(), do: try_get("message/quota/consumption")

  @doc """
  Calls the [Get number of sent reply messages](https://developers.line.biz/en/reference/messaging-api/#get-number-of-reply-messages) API.
  """
  @spec get_sent_reply_count(date :: String.t()) :: api_response()
  def get_sent_reply_count(date), do: try_get("message/delivery/reply", date: date)

  @doc """
  Calls the [Get number of sent push messages](https://developers.line.biz/en/reference/messaging-api/#get-number-of-push-messages) API.
  """
  @spec get_sent_push_count(date :: String.t()) :: api_response()
  def get_sent_push_count(date), do: try_get("message/delivery/push", date: date)

  @doc """
  Calls the [Get number of sent multicast messages](https://developers.line.biz/en/reference/messaging-api/#get-number-of-multicast-messages) API.
  """
  @spec get_sent_multicast_count(date :: String.t()) :: api_response()
  def get_sent_multicast_count(date), do: try_get("message/delivery/multicast", date: date)

  @doc """
  Calls the [Get number of sent broadcast messages](https://developers.line.biz/en/reference/messaging-api/#get-number-of-broadcast-messages) API.
  """
  @spec get_sent_broadcast_count(date :: String.t()) :: api_response()
  def get_sent_broadcast_count(date), do: try_get("message/delivery/broadcast", date: date)

  @doc """
  Calls the [Get number of message deliveries](https://developers.line.biz/en/reference/messaging-api/#get-number-of-delivery-messages) API.
  """
  @spec get_sent_message_count(date :: String.t()) :: api_response()
  def get_sent_message_count(date), do: try_get("insight/message/delivery", date: date)

  @doc """
  Calls the [Get number of followers](https://developers.line.biz/en/reference/messaging-api/#get-number-of-followers) API.
  """
  @spec get_follower_count(date :: String.t()) :: api_response()
  def get_follower_count(date), do: try_get("insight/followers", date: date)

  @doc """
  Calls the [Get friend demographics](https://developers.line.biz/en/reference/messaging-api/#get-demographic) API.
  """
  @spec get_follower_demographics() :: api_response()
  def get_follower_demographics(), do: try_get("insight/demographic")

  @doc """
  Calls the [Get profile](https://developers.line.biz/en/reference/messaging-api/#get-profile) API.
  """
  @spec get_profile(user_id :: String.t()) :: api_response()
  def get_profile(user_id), do: try_get("profile/#{user_id}")

  @doc """
  Calls the [Get group member user IDs](https://developers.line.biz/en/reference/messaging-api/#get-group-member-user-ids) API.
  """
  @spec get_group_member_ids(group_id :: String.t(), start :: binary() | nil) :: api_response()
  def get_group_member_ids(group_id, start \\ nil) do
    start = if start, do: [start: start], else: []
    try_get("group/#{group_id}/members/ids", start)
  end

  @doc """
  Calls the [Get group member profile](https://developers.line.biz/en/reference/messaging-api/#get-group-member-profile) API.
  """
  @spec get_group_member_profile(group_id :: String.t(), user_id :: String.t()) :: api_response()
  def get_group_member_profile(group_id, user_id) do
    try_get("group/#{group_id}/member/#{user_id}")
  end

  @doc """
  Calls the [Leave group](https://developers.line.biz/en/reference/messaging-api/#leave-group) API.
  """
  @spec leave_group(group_id :: String.t()) :: api_response()
  def leave_group(group_id), do: try_post("group/#{group_id}/leave")

  @doc """
  Calls the [Get room member user IDs](https://developers.line.biz/en/reference/messaging-api/#get-room-member-user-ids) API.
  """
  @spec get_room_member_ids(room_id :: String.t(), start :: binary() | nil) :: api_response()
  def get_room_member_ids(room_id, start \\ nil) do
    start = if start, do: [start: start], else: []
    try_get("room/#{room_id}/members/ids", start)
  end

  @doc """
  Calls the [Get room member profile](https://developers.line.biz/en/reference/messaging-api/#get-room-member-profile) API.
  """
  @spec get_room_member_profile(room_id :: String.t(), user_id :: String.t()) :: api_response()
  def get_room_member_profile(room_id, user_id), do: try_get("room/#{room_id}/member/#{user_id}")

  @doc """
  Calls the [Leave room](https://developers.line.biz/en/reference/messaging-api/#leave-room) API.
  """
  @spec leave_room(room_id :: String.t()) :: api_response()
  def leave_room(room_id), do: try_post("room/#{room_id}/leave")

  @doc """
  Calls the [Issue link token](https://developers.line.biz/en/reference/messaging-api/#issue-link-token) API.
  """
  @spec issue_link_token(user_id :: String.t()) :: api_response()
  def issue_link_token(user_id), do: try_post("user/#{user_id}/linkToken")
end
