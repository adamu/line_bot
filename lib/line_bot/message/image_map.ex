defmodule LineBot.Message.Imagemap do
  use LineBot.Message

  @moduledoc """
  Represents an [Imagemap message](https://developers.line.biz/en/reference/messaging-api/#imagemap-message).
  """
  @type t :: %__MODULE__{
          baseUrl: String.t(),
          altText: String.t(),
          baseSize: %{width: integer(), height: integer()},
          video: LineBot.Message.Imagemap.Video.t() | nil,
          actions: [
            LineBot.Message.Imagemap.Action.Message.t() | LineBot.Message.Imagemap.Action.URI.t()
          ],
          type: :imagemap,
          quickReply: LineBot.Message.QuickReply.t() | nil
        }
  @enforce_keys [:baseUrl, :altText, :baseSize, :actions]
  defstruct [:baseUrl, :altText, :baseSize, :video, :actions, :quickReply, type: :imagemap]
end

defmodule LineBot.Message.Imagemap.Video do
  use LineBot.Message

  @moduledoc """
  Represents the video component of a `t:LineBot.Message.Imagemap.t/0`.
  """
  @type t :: %__MODULE__{
          originalContentUrl: String.t(),
          previewImageUrl: String.t(),
          area: %{x: integer(), y: integer(), width: integer(), height: integer()},
          externalLink: %{linkUri: String.t(), label: String.t()} | nil
        }
  @enforce_keys [:originalContentUrl, :previewImageUrl, :area]
  defstruct [:originalContentUrl, :previewImageUrl, :area, :externalLink]
end

defmodule LineBot.Message.Imagemap.Action.Message do
  use LineBot.Message

  @moduledoc """
  Represents an [Imagemap Message action object](https://developers.line.biz/en/reference/messaging-api/#imagemap-message-action-object).
  """
  @type t :: %__MODULE__{
          label: String.t() | nil,
          text: String.t(),
          area: %{x: integer(), y: integer(), width: integer(), height: integer()},
          type: :message
        }
  @enforce_keys [:text, :area]
  defstruct [:label, :text, :area, type: :message]
end

defmodule LineBot.Message.Imagemap.Action.URI do
  use LineBot.Message

  @moduledoc """
  Represents an [Imagemap URI action object](https://developers.line.biz/en/reference/messaging-api/#imagemap-uri-action-object).
  """
  @type t :: %__MODULE__{
          label: String.t() | nil,
          linkUri: String.t(),
          area: %{x: integer(), y: integer(), width: integer(), height: integer()},
          type: :uri
        }
  @enforce_keys [:linkUri, :area]
  defstruct [:label, :linkUri, :area, type: :uri]
end
