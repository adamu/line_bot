defmodule LineBotTest do
  use ExUnit.Case, async: true
  import LineBot.TestHelpers
  import Mox

  test "defines callbacks for every event" do
    expected_callbacks = [
      handle_unfollow: 1,
      handle_things: 3,
      handle_postback: 3,
      handle_other: 4,
      handle_message: 3,
      handle_member_left: 2,
      handle_member_joined: 3,
      handle_leave: 1,
      handle_join: 2,
      handle_follow: 2,
      handle_beacon: 3,
      handle_account_link: 3
    ]

    assert LineBot.behaviour_info(:callbacks) == expected_callbacks
    assert LineBot.behaviour_info(:optional_callbacks) == expected_callbacks
  end

  test_post_msg :send_reply, "message/reply", "token", %{
    "replyToken" => "token",
    "messages" => ["message"],
    "notificationDisabled" => "disabled"
  }

  test_post_msg :send_push, "message/push", "to", %{
    "to" => "to",
    "messages" => ["message"],
    "notificationDisabled" => "disabled"
  }

  test_post_msg :send_multicast, "message/multicast", ["to"], %{
    "to" => ["to"],
    "messages" => ["message"],
    "notificationDisabled" => "disabled"
  }

  test_post_msg :send_broadcast, "message/broadcast", nil, %{
    "messages" => ["message"],
    "notificationDisabled" => "disabled"
  }

  test_post_uri :leave_group, "group/group_id/leave", "group_id"
  test_post_uri :leave_room, "room/room_id/leave", "room_id"
  test_post_uri :issue_link_token, "user/user_id/linkToken", "user_id"

  test_get_for :get_quota, "message/quota", ["date"], date: "date"
  test_get_for :get_sent_reply_count, "message/delivery/reply", ["date"], date: "date"
  test_get_for :get_sent_push_count, "message/delivery/push", ["date"], date: "date"
  test_get_for :get_sent_multicast_count, "message/delivery/multicast", ["date"], date: "date"
  test_get_for :get_sent_broadcast_count, "message/delivery/broadcast", ["date"], date: "date"
  test_get_for :get_sent_message_count, "insight/message/delivery", ["date"], date: "date"
  test_get_for :get_follower_count, "insight/followers", ["date"], date: "date"
  test_get_for :get_quota_consumption, "message/quota/consumption", [], []
  test_get_for :get_follower_demographics, "insight/demographic", [], []
  test_get_for :get_profile, "profile/profile_id", ["profile_id"], []
  test_get_for :get_group_member_ids, "group/group_id/members/ids", ["group_id"], []
  test_get_for :get_room_member_ids, "room/room_id/members/ids", ["room_id"], []

  test_get_for :get_group_member_profile,
               "group/group_id/member/user_id",
               ["group_id", "user_id"],
               []

  test_get_for :get_room_member_profile,
               "room/room_id/member/user_id",
               ["room_id", "user_id"],
               []

  test "get_content/1" do
    response = %HTTPoison.Response{body: "dummy"}
    expect(MockAPIClient, :get!, fn "message/1/content" -> response end)

    assert response == LineBot.get_content("1")
  end
end
