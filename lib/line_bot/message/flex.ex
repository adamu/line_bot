defmodule LineBot.Message.Flex do
  use LineBot.Message

  @moduledoc """
  Represents a [Flex message](https://developers.line.biz/en/reference/messaging-api/#flex-message).
  """
  @type t :: %__MODULE__{
          altText: String.t(),
          contents: LineBot.Message.Flex.Carousel.t() | LineBot.Message.Flex.Bubble.t(),
          type: :flex,
          quickReply: LineBot.Message.QuickReply.t() | nil
        }

  @type component ::
          LineBot.Message.Flex.Box.t()
          | LineBot.Message.Flex.Button.t()
          | LineBot.Message.Flex.Filler.t()
          | LineBot.Message.Flex.Image.t()
          | LineBot.Message.Flex.Separator.t()
          | LineBot.Message.Flex.Spacer.t()
          | LineBot.Message.Flex.Text.t()
          | LineBot.Message.Flex.Icon.t()

  @enforce_keys [:altText, :contents]
  defstruct [:altText, :contents, :quickReply, type: :flex]
end

# Containers

defmodule LineBot.Message.Flex.Carousel do
  use LineBot.Message

  @moduledoc """
  Represents a [Carousel container](https://developers.line.biz/en/reference/messaging-api/#f-carousel).
  """
  @type t :: %__MODULE__{
          contents: [LineBot.Message.Flex.Bubble.t()],
          type: :carousel
        }
  defstruct [:contents, type: :carousel]
end

defmodule LineBot.Message.Flex.Bubble do
  use LineBot.Message

  @moduledoc """
  Represents a [Bubble container](https://developers.line.biz/en/reference/messaging-api/#bubble).
  """
  @type t :: %__MODULE__{
          direction: :ltr | :rtl | nil,
          header: LineBot.Message.Flex.Box.t() | nil,
          hero: LineBot.Message.Flex.Image.t() | nil,
          body: LineBot.Message.Flex.Box.t() | nil,
          footer: LineBot.Message.Flex.Box.t() | nil,
          styles: LineBot.Message.Flex.BubbleStyle.t() | nil,
          type: :bubble
        }
  defstruct [:direction, :header, :hero, :body, :footer, :styles, type: :bubble]
end

defmodule LineBot.Message.Flex.BubbleStyle do
  use LineBot.Message

  @moduledoc """
  Represents a [Bubble style](https://developers.line.biz/en/reference/messaging-api/#bubble-style).
  """
  @type t :: %__MODULE__{
          header: LineBot.Message.Flex.BubbleStyleBlock.t() | nil,
          hero: LineBot.Message.Flex.BubbleStyleBlock.t() | nil,
          body: LineBot.Message.Flex.BubbleStyleBlock.t() | nil,
          footer: LineBot.Message.Flex.BubbleStyleBlock.t() | nil
        }
  defstruct [:header, :hero, :body, :footer]
end

defmodule LineBot.Message.Flex.BubbleStyleBlock do
  use LineBot.Message

  @moduledoc """
  Represents a [Block bubble style](https://developers.line.biz/en/reference/messaging-api/#block-style).
  """
  @type t :: %__MODULE__{
          backgroundColor: String.t() | nil,
          separator: boolean() | nil,
          separatorColor: String.t() | nil
        }
  defstruct [:backgroundColor, :separator, :separatorColor]
end

# Components

defmodule LineBot.Message.Flex.Box do
  use LineBot.Message

  @moduledoc """
  Represents a [Box component](https://developers.line.biz/en/reference/messaging-api/#box).
  """
  @type t :: %__MODULE__{
          layout: :horizontal | :vertical | :baseline,
          contents: [LineBot.Message.Flex.component()],
          flex: integer() | nil,
          spacing: :none | :xs | :sm | :md | :lg | :xl | :xxl | nil,
          margin: :none | :xs | :sm | :md | :lg | :xl | :xxl | nil,
          action: [LineBot.Message.Action.t()] | nil,
          type: :box
        }
  @enforce_keys [:layout, :contents]
  defstruct [:layout, :contents, :flex, :spacing, :margin, :action, type: :box]
end

defmodule LineBot.Message.Flex.Button do
  use LineBot.Message

  @moduledoc """
  Represents a [Button component](https://developers.line.biz/en/reference/messaging-api/#button).
  """
  @type t :: %__MODULE__{
          action: LineBot.Message.Action.t(),
          flex: integer() | nil,
          margin: :none | :xs | :sm | :md | :lg | :xl | :xxl | nil,
          height: :sm | :md | nil,
          style: :link | :primary | :secondary | nil,
          color: String.t() | nil,
          gravity: :top | :bottom | :center | nil,
          type: :button
        }
  @enforce_keys [:action]
  defstruct [:action, :flex, :margin, :height, :style, :color, :gravity, type: :button]
end

defmodule LineBot.Message.Flex.Filler do
  @derive Jason.Encoder
  @moduledoc """
  Represents a [Filler component](https://developers.line.biz/en/reference/messaging-api/#filler).
  """
  @type t :: %__MODULE__{type: :filler}
  defstruct type: :filler
end

defmodule LineBot.Message.Flex.Icon do
  use LineBot.Message

  @moduledoc """
  Represents an [Icon component](https://developers.line.biz/en/reference/messaging-api/#icon).
  """
  @type t :: %__MODULE__{
          url: String.t(),
          margin: :none | :xs | :sm | :md | :lg | :xl | :xxl | nil,
          size: :none | :xs | :sm | :md | :lg | :xl | :xxl | :"3xl" | :"4xl" | :"5xl" | nil,
          aspectRatio: String.t() | nil,
          type: :icon
        }
  @enforce_keys [:url]
  defstruct [:url, :margin, :size, :aspectRatio, type: :icon]
end

defmodule LineBot.Message.Flex.Image do
  use LineBot.Message

  @moduledoc """
  Represents an [Image component](https://developers.line.biz/en/reference/messaging-api/#f-image).
  """
  @type t :: %__MODULE__{
          url: String.t(),
          flex: integer() | nil,
          margin: :none | :xs | :sm | :md | :lg | :xl | :xxl | nil,
          align: :start | :end | :center | nil,
          gravity: :top | :bottom | :center | nil,
          size:
            :none | :xs | :sm | :md | :lg | :xl | :xxl | :"3xl" | :"4xl" | :"5xl" | :full | nil,
          aspectRatio: String.t() | nil,
          aspectMode: :cover | :fit | nil,
          backgroundColor: String.t() | nil,
          action: LineBot.Message.Action.t() | nil,
          type: :image
        }
  @enforce_keys [:url]
  defstruct [
    :url,
    :flex,
    :margin,
    :align,
    :gravity,
    :size,
    :aspectRatio,
    :aspectMode,
    :backgroundColor,
    :action,
    type: :image
  ]
end

defmodule LineBot.Message.Flex.Separator do
  use LineBot.Message

  @moduledoc """
  Represents a [Separator component](https://developers.line.biz/en/reference/messaging-api/#separator).
  """
  @type t :: %__MODULE__{
          margin: :none | :xs | :sm | :md | :lg | :xl | :xxl | nil,
          color: String.t() | nil,
          type: :separator
        }
  defstruct [:margin, :color, type: :separator]
end

defmodule LineBot.Message.Flex.Spacer do
  use LineBot.Message

  @moduledoc """
  Represents a [Spacer component](https://developers.line.biz/en/reference/messaging-api/#spacer).
  """
  @type t :: %__MODULE__{
          size: :none | :xs | :sm | :md | :lg | :xl | :xxl | nil,
          type: :separator
        }
  defstruct [:size, type: :spacer]
end

defmodule LineBot.Message.Flex.Text do
  use LineBot.Message

  @moduledoc """
  Represents an [Text component](https://developers.line.biz/en/reference/messaging-api/#f-text).
  """
  @type t :: %__MODULE__{
          text: String.t(),
          flex: integer() | nil,
          margin: :none | :xs | :sm | :md | :lg | :xl | :xxl | nil,
          size: :none | :xs | :sm | :md | :lg | :xl | :xxl | :"3xl" | :"4xl" | :"5xl" | nil,
          align: :start | :end | :center | nil,
          gravity: :top | :bottom | :center | nil,
          wrap: boolean() | nil,
          maxLines: integer() | nil,
          weight: :regular | :bold | nil,
          color: String.t() | nil,
          action: LineBot.Message.Action.t() | nil,
          type: :text
        }
  @enforce_keys [:text]
  defstruct [
    :text,
    :flex,
    :margin,
    :size,
    :align,
    :gravity,
    :wrap,
    :maxLines,
    :weight,
    :color,
    :action,
    type: :text
  ]
end
