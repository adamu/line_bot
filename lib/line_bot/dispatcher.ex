defmodule LineBot.Dispatcher do
  @moduledoc false

  def dispatch_events([], _destination, _callback), do: :ok

  def dispatch_events([event | events], destination, callback) do
    dispatch_event(event, destination, callback)
    dispatch_events(events, destination, callback)
  end

  defp dispatch_event(event, destination, callback) do
    info = %LineBot.EventInfo{
      user_id: event["source"]["userId"],
      source: event["source"],
      destination: destination,
      timestamp: DateTime.from_unix!(event["timestamp"], :millisecond)
    }

    async(callback, handler(event["type"], event, info))
  end

  defp async(callback, {function, args}) do
    Task.Supervisor.start_child(LineBot.TaskSupervisor, fn -> apply(callback, function, args) end)
  end

  defp handler("message", event, info) do
    {:handle_message, [event["message"], info, event["replyToken"]]}
  end

  defp handler("follow", event, info) do
    {:handle_follow, [info, event["replyToken"]]}
  end

  defp handler("unfollow", _event, info) do
    {:handle_unfollow, [info]}
  end

  defp handler("join", event, info) do
    {:handle_join, [info, event["replyToken"]]}
  end

  defp handler("leave", _event, info) do
    {:handle_leave, [info]}
  end

  defp handler("memberJoined", event, info) do
    {:handle_member_joined, [event["joined"]["members"], info, event["replyToken"]]}
  end

  defp handler("memberLeft", event, info) do
    {:handle_member_left, [event["left"]["members"], info]}
  end

  defp handler("postback", event, info) do
    {:handle_postback, [event["postback"], info, event["replyToken"]]}
  end

  defp handler("beacon", event, info) do
    {:handle_beacon, [event["beacon"], info, event["replyToken"]]}
  end

  defp handler("accountLink", event, info) do
    {:handle_account_link, [event["link"], info, event["replyToken"]]}
  end

  defp handler("things", event, info) do
    {:handle_things, [event["things"], info, event["replyToken"]]}
  end

  defp handler(type, event, info) do
    {:handle_other, [type, event, info, event["replyToken"]]}
  end
end
