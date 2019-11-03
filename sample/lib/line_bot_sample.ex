defmodule LineBotSample do
  use LineBot
  require Logger

  alias LineBot.Message
  # ----------------------------------------------------------------------------
  # Helpers
  # ----------------------------------------------------------------------------
  defp log_and_reply(request_message, reply_message, reply_token) do
    Logger.info("Handling message event: #{inspect request_message}")
    LineBot.send_reply(reply_token, [reply_message])
  end

  @help %Message.Text{
    text: """
    Available demo commands:

    help
    text
    sticker
    image
    video
    audio
    location
    flex
    imagemap
    imagemap video
    template
    quick
    flag <code>
    """
  }

  # ----------------------------------------------------------------------------
  # Message Event
  # ----------------------------------------------------------------------------
  @impl true
  def handle_message(%{"type" => "text", "text" => "help"} = request_message, _info, reply_token) do
    log_and_reply(request_message, @help, reply_token)
  end

  @impl true
  def handle_message(%{"type" => "text", "text" => "text"} = request_message, _info, reply_token) do
    reply_message = %Message.Text{text: "Hello \u{10008D}"}
    log_and_reply(request_message, reply_message, reply_token)
  end

  @impl true
  def handle_message(
        %{"type" => "text", "text" => "sticker"} = request_message,
        _info,
        reply_token
      ) do
    reply_message = %Message.Sticker{packageId: 11537, stickerId: 52_002_769}
    log_and_reply(request_message, reply_message, reply_token)
  end

  @impl true
  def handle_message(%{"type" => "text", "text" => "image"} = request_message, _info, reply_token) do
    reply_message = %Message.Image{
      originalContentUrl: "https://adamu.github.io/images/full.jpg",
      previewImageUrl: "https://adamu.github.io/images/preview.jpg"
    }

    log_and_reply(request_message, reply_message, reply_token)
  end

  @impl true
  def handle_message(%{"type" => "text", "text" => "video"} = request_message, _info, reply_token) do
    reply_message = %Message.Video{
      originalContentUrl: "https://adamu.github.io/images/video.mp4",
      previewImageUrl: "https://adamu.github.io/images/video_preview.jpg"
    }

    log_and_reply(request_message, reply_message, reply_token)
  end

  @impl true
  def handle_message(%{"type" => "text", "text" => "audio"} = request_message, _info, reply_token) do
    reply_message = %Message.Audio{
      originalContentUrl: "https://adamu.github.io/images/audio.m4a",
      duration: 60_000
    }

    log_and_reply(request_message, reply_message, reply_token)
  end

  @impl true
  def handle_message(
        %{"type" => "text", "text" => "location"} = request_message,
        _info,
        reply_token
      ) do
    reply_message = %Message.Location{
      title: "Kyoto Station",
      address: "京都府京都市下京区東塩小路高倉町8-3",
      latitude: 34.985407,
      longitude: 135.75845
    }

    log_and_reply(request_message, reply_message, reply_token)
  end

  @impl true
  def handle_message(%{"type" => "text", "text" => "flex"} = request_message, _info, reply_token) do
    reply_message = LineBotSample.Flex.make_flex_message()
    log_and_reply(request_message, reply_message, reply_token)
  end

  @impl true
  def handle_message(
        %{"type" => "text", "text" => "imagemap"} = request_message,
        _info,
        reply_token
      ) do
    reply_message = LineBotSample.Imagemap.make_imagemap_message()
    log_and_reply(request_message, reply_message, reply_token)
  end

  @impl true
  def handle_message(
        %{"type" => "text", "text" => "imagemap video"} = request_message,
        _,
        reply_token
      ) do
    reply_message = LineBotSample.Imagemap.make_imagemap_video_message()
    log_and_reply(request_message, reply_message, reply_token)
  end

  @impl true
  def handle_message(
        %{"type" => "text", "text" => "template"} = request_message,
        _info,
        reply_token
      ) do
    reply_message = %Message.Template{
      altText: "Please select an option",
      template: %Message.Template.Confirm{
        text: "Please select an option",
        actions: [
          %Message.Action.Message{label: "Yes", text: "Yes"},
          %Message.Action.Message{label: "No", text: "No"}
        ]
      }
    }

    log_and_reply(request_message, reply_message, reply_token)
  end

  @impl true
  def handle_message(%{"type" => "text", "text" => "quick"} = request_message, _info, reply_token) do
    quick_reply = %Message.QuickReply{
      items: [
        %Message.QuickReplyItem{
          action: %Message.Action.Postback{
            label: "line bot postback",
            data: "line bot postback data",
            displayText: "Line Bot Postback!"
          }
        }
      ]
    }

    reply_message = %Message.Text{
      text: "Quick reply please!",
      quickReply: quick_reply
    }

    log_and_reply(request_message, reply_message, reply_token)
  end

  # Fun example that converts country codes to unicode flags by shifting
  # the input up to the "Regional Indicator Symbol" unicode block.
  # e.g. flag gb => 🇬🇧
  @impl true
  def handle_message(
        %{"type" => "text", "text" => "flag " <> code} = request_message,
        _info,
        reply_token
      ) do
    code =
      code
      |> String.trim()
      |> String.upcase()
      |> String.to_charlist()
      |> Enum.map(&(&1 + 0x1F1A5))
      |> List.to_string()

    log_and_reply(request_message, %Message.Text{text: code}, reply_token)
  end

  @impl true
  def handle_message(message, info, _reply_token) do
    Logger.info("Handling message event: #{inspect message}\n#{inspect info}")
  end

  # ----------------------------------------------------------------------------
  # Follow Event
  # ----------------------------------------------------------------------------
  @impl true
  def handle_follow(info, reply_token) do
    Logger.info("Handling follow event: " <> inspect(info))
    LineBot.send_reply(reply_token, [@help])
  end

  # ----------------------------------------------------------------------------
  # Unfollow Event
  # ----------------------------------------------------------------------------
  @impl true
  def handle_unfollow(info) do
    Logger.info("Handling unfollow event: " <> inspect(info))
  end

  # ----------------------------------------------------------------------------
  # Join Event
  # ----------------------------------------------------------------------------
  @impl true
  def handle_join(info, _reply_token) do
    Logger.info("Handling join event: " <> inspect(info))
  end

  # ----------------------------------------------------------------------------
  # Leave Event
  # ----------------------------------------------------------------------------
  @impl true
  def handle_leave(info) do
    Logger.info("Handling leave event: " <> inspect(info))
  end

  # ----------------------------------------------------------------------------
  # Member Joined Event
  # ----------------------------------------------------------------------------
  @impl true
  def handle_member_joined(members, info, _reply_token) do
    Logger.info("Handling member_joined event: #{inspect members}")
    Logger.info(inspect(info))
  end

  # ----------------------------------------------------------------------------
  # Member Left Event
  # ----------------------------------------------------------------------------
  @impl true
  def handle_member_left(members, info) do
    Logger.info("Handling member_left event: #{inspect members}")
    Logger.info(inspect(info))
  end

  # ----------------------------------------------------------------------------
  # Postback Event
  # ----------------------------------------------------------------------------
  @impl true
  def handle_postback(postback, info, _reply_token) do
    Logger.info("Handling postback event: #{inspect postback}")
    Logger.info(inspect(info))
  end

  # ----------------------------------------------------------------------------
  # Beacon Event
  # ----------------------------------------------------------------------------
  @impl true
  def handle_beacon(beacon, info, _reply_token) do
    Logger.info("Handling beacon event: #{inspect beacon}")
    Logger.info(inspect(info))
  end

  # ----------------------------------------------------------------------------
  # Account Link Event
  # ----------------------------------------------------------------------------
  @impl true
  def handle_account_link(link, info, _reply_token) do
    Logger.info("Handling account_link event: #{inspect link}")
    Logger.info(inspect(info))
  end

  # ----------------------------------------------------------------------------
  # Things Event
  # ----------------------------------------------------------------------------
  @impl true
  def handle_things(things, info, _reply_token) do
    Logger.info("Handling things event: #{inspect things}")
    Logger.info(inspect(info))
  end

  # ----------------------------------------------------------------------------
  # Unknown Event Type
  # ----------------------------------------------------------------------------
  @impl true
  def handle_other(type, event, info, reply_token) do
    Logger.info("Handling unknown #{type} event: #{inspect event}")
    Logger.info(inspect(info))
    Logger.info(inspect reply_token)
  end
end
