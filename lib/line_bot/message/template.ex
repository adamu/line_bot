defmodule LineBot.Message.Template do
  use LineBot.Message

  @moduledoc """
  Represents a [Template message](https://developers.line.biz/en/reference/messaging-api/#template-messages).
  """
  @type t :: %__MODULE__{
          altText: String.t(),
          template:
            LineBot.Message.Template.Buttons.t()
            | LineBot.Message.Template.Confirm.t()
            | LineBot.Message.Template.Carousel.t()
            | LineBot.Message.Template.ImageCarousel.t(),
          type: :template,
          quickReply: LineBot.Message.QuickReply.t() | nil
        }
  @enforce_keys [:altText, :template]
  defstruct [:altText, :template, :quickReply, type: :template]
end

defmodule LineBot.Message.Template.Buttons do
  use LineBot.Message

  @moduledoc """
  Represents a [Buttons template](https://developers.line.biz/en/reference/messaging-api/#buttons).
  """
  @type t :: %__MODULE__{
          thumbnailImageUrl: String.t() | nil,
          imageAspectRatio: :rectangle | :square | nil,
          imageSize: :cover | :contain | nil,
          imageBackgroundColor: String.t() | nil,
          title: String.t() | nil,
          text: String.t(),
          defaultAction: LineBot.Message.Action.t() | nil,
          actions: [LineBot.Message.Action.t()],
          type: :buttons
        }
  @enforce_keys [:text, :actions]
  defstruct [
    :thumbnailImageUrl,
    :imageAspectRatio,
    :imageSize,
    :imageBackgroundColor,
    :title,
    :text,
    :defaultAction,
    :actions,
    type: :buttons
  ]
end

defmodule LineBot.Message.Template.Confirm do
  @derive Jason.Encoder
  @moduledoc """
  Represents a [Confirm template](https://developers.line.biz/en/reference/messaging-api/#confirm).
  """
  @type t :: %__MODULE__{
          text: String.t(),
          actions: [LineBot.Message.Action.t()],
          type: :confirm
        }
  @enforce_keys [:text, :actions]
  defstruct [:text, :actions, type: :confirm]
end

defmodule LineBot.Message.Template.Carousel do
  use LineBot.Message

  @moduledoc """
  Represents a [Carousel template](https://developers.line.biz/en/reference/messaging-api/#carousel).
  """
  @type t :: %__MODULE__{
          columns: [LineBot.Message.Template.Carousel.Column.t()],
          imageAspectRatio: :rectangle | :square | nil,
          imageSize: :cover | :contain | nil,
          type: :carousel
        }
  @enforce_keys [:columns]
  defstruct [:columns, :imageAspectRatio, :imageSize, type: :carousel]
end

defmodule LineBot.Message.Template.Carousel.Column do
  use LineBot.Message

  @moduledoc """
  Represents a [Column object for carousel](https://developers.line.biz/en/reference/messaging-api/#column-object-for-carousel).
  """
  @type t :: %__MODULE__{
          thumbnailImageUrl: String.t() | nil,
          imageBackgroundColor: String.t() | nil,
          title: String.t() | nil,
          text: String.t(),
          defaultAction: LineBot.Message.Action.t() | nil,
          actions: [LineBot.Message.Action.t()]
        }
  @enforce_keys [:text]
  defstruct [:thumbnailImageUrl, :imageBackgroundColor, :title, :text, :defaultAction, :actions]
end

defmodule LineBot.Message.Template.ImageCarousel do
  @derive Jason.Encoder
  @moduledoc """
  Represents an [Image carousel template](https://developers.line.biz/en/reference/messaging-api/#image-carousel).
  """
  @type t :: %__MODULE__{
          columns: [LineBot.Message.Template.ImageCarousel.Column.t()],
          type: :image_carousel
        }
  @enforce_keys [:columns]
  defstruct [:columns, type: :image_carousel]
end

defmodule LineBot.Message.Template.ImageCarousel.Column do
  @derive Jason.Encoder
  @moduledoc """
  Represents a [Column object for image carousel](https://developers.line.biz/en/reference/messaging-api/#column-object-for-image-carousel).
  """
  @type t :: %__MODULE__{
          imageUrl: String.t(),
          action: LineBot.Message.Action.t()
        }
  @enforce_keys [:imageUrl, :action]
  defstruct [:imageUrl, :action]
end
