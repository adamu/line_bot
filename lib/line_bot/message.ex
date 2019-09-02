defmodule LineBot.Message do
  @moduledoc """
  Represents any of the possible [Message objects](https://developers.line.biz/en/reference/messaging-api/#message-objects).
  """
  @type t ::
          LineBot.Message.Text.t()
          | LineBot.Message.Sticker.t()
          | LineBot.Message.Image.t()
          | LineBot.Message.Video.t()
          | LineBot.Message.Audio.t()
          | LineBot.Message.Location.t()
          | LineBot.Message.Flex.t()
          | LineBot.Message.Imagemap.t()
          | LineBot.Message.Template.t()

  defmacro __using__(_opts) do
    quote do
      defimpl Jason.Encoder do
        def encode(struct, opts) do
          struct
          |> Map.from_struct()
          |> Enum.reject(&(elem(&1, 1) == nil))
          |> Map.new()
          |> Jason.Encode.map(opts)
        end
      end
    end
  end
end

defmodule LineBot.Message.Text do
  use LineBot.Message

  @moduledoc """
  Represents a [Text message](https://developers.line.biz/en/reference/messaging-api/#text-message).
  """
  @type t :: %__MODULE__{
          text: String.t(),
          type: :text,
          quickReply: LineBot.Message.QuickReply.t() | nil
        }
  @enforce_keys [:text]
  defstruct [:text, :quickReply, type: :text]
end

defmodule LineBot.Message.Sticker do
  use LineBot.Message

  @moduledoc """
  Represents a [Sticker message](https://developers.line.biz/en/reference/messaging-api/#sticker-message).
  """
  @type t :: %__MODULE__{
          packageId: String.t(),
          stickerId: String.t(),
          type: :sticker,
          quickReply: LineBot.Message.QuickReply.t() | nil
        }
  @enforce_keys [:packageId, :stickerId]
  defstruct [:packageId, :stickerId, :quickReply, type: :sticker]
end

defmodule LineBot.Message.Image do
  use LineBot.Message

  @moduledoc """
  Represents an [Image message](https://developers.line.biz/en/reference/messaging-api/#image-message).
  """
  @type t :: %__MODULE__{
          originalContentUrl: String.t(),
          previewImageUrl: String.t(),
          type: :image,
          quickReply: LineBot.Message.QuickReply.t() | nil
        }
  @enforce_keys [:originalContentUrl, :previewImageUrl]
  defstruct [:originalContentUrl, :previewImageUrl, :quickReply, type: :image]
end

defmodule LineBot.Message.Video do
  use LineBot.Message

  @moduledoc """
  Represents a [Video message](https://developers.line.biz/en/reference/messaging-api/#video-message).
  """
  @type t :: %__MODULE__{
          originalContentUrl: String.t(),
          previewImageUrl: String.t(),
          type: :video,
          quickReply: LineBot.Message.QuickReply.t() | nil
        }
  @enforce_keys [:originalContentUrl, :previewImageUrl]
  defstruct [:originalContentUrl, :previewImageUrl, :quickReply, type: :video]
end

defmodule LineBot.Message.Audio do
  use LineBot.Message

  @moduledoc """
  Represents an [Audio message](https://developers.line.biz/en/reference/messaging-api/#audio-message).
  """
  @type t :: %__MODULE__{
          originalContentUrl: String.t(),
          duration: number(),
          type: :audio,
          quickReply: LineBot.Message.QuickReply.t() | nil
        }
  @enforce_keys [:originalContentUrl, :duration]
  defstruct [:originalContentUrl, :duration, :quickReply, type: :audio]
end

defmodule LineBot.Message.Location do
  use LineBot.Message

  @moduledoc """
  Represents a [Location message](https://developers.line.biz/en/reference/messaging-api/#location-message).
  """
  @type t :: %__MODULE__{
          title: String.t(),
          address: String.t(),
          latitude: float(),
          longitude: float(),
          quickReply: LineBot.Message.QuickReply.t() | nil
        }
  @enforce_keys [:title, :address, :latitude, :longitude]
  defstruct [:title, :address, :latitude, :longitude, :quickReply, type: :location]
end
