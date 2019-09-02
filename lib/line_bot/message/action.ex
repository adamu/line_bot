defmodule LineBot.Message.Action do
  @moduledoc """
  Represents any one of the possible [Action objects](https://developers.line.biz/en/reference/messaging-api/#action-objects).
  """

  @type t() ::
          LineBot.Message.Action.Message.t()
          | LineBot.Message.Action.URI.t()
          | LineBot.Message.Action.DateTimePicker.t()
          | LineBot.Message.Action.Camera.t()
          | LineBot.Message.Action.CameraRoll.t()
          | LineBot.Message.Action.Location.t()
end

defmodule LineBot.Message.Action.Postback do
  @moduledoc """
  Represents a [Postback action](https://developers.line.biz/en/reference/messaging-api/#postback-action).
  """
  use LineBot.Message

  @type t :: %__MODULE__{
          label: String.t(),
          data: String.t(),
          displayText: String.t(),
          type: :postback
        }
  @enforce_keys [:data]
  defstruct [:label, :data, :displayText, type: :postback]
end

defmodule LineBot.Message.Action.Message do
  @moduledoc """
  Represents a [Message action](https://developers.line.biz/en/reference/messaging-api/#message-action).
  """
  use LineBot.Message

  @type t :: %__MODULE__{
          label: String.t(),
          text: String.t(),
          type: :message
        }
  @enforce_keys [:text]
  defstruct [:label, :text, type: :message]
end

defmodule LineBot.Message.Action.URI do
  @moduledoc """
  Represents a [URI action](https://developers.line.biz/en/reference/messaging-api/#postback-action).
  """
  use LineBot.Message

  @type t :: %__MODULE__{
          label: String.t(),
          uri: String.t(),
          altUri: %{desktop: :http | :https | :line | :tel},
          type: :uri
        }
  @enforce_keys [:uri]
  defstruct [:label, :uri, :altUri, type: :uri]
end

defmodule LineBot.Message.Action.DateTimePicker do
  @moduledoc """
  Represents a [Datetime picker action](https://developers.line.biz/en/reference/messaging-api/#postback-action).
  """
  use LineBot.Message

  @type t :: %__MODULE__{
          label: String.t(),
          data: String.t(),
          mode: :date | :time | :datetime,
          initial: String.t(),
          max: String.t(),
          min: String.t(),
          type: :datetimepicker
        }
  @enforce_keys [:data, :mode]
  defstruct [:label, :data, :mode, :initial, :max, :min, type: :datetimepicker]
end

defmodule LineBot.Message.Action.Camera do
  @moduledoc """
  Represents a [Camera action](https://developers.line.biz/en/reference/messaging-api/#postback-action).
  """
  @derive Jason.Encoder
  @type t :: %__MODULE__{
          label: String.t(),
          type: :camera
        }
  @enforce_keys [:label]
  defstruct [:label, type: :camera]
end

defmodule LineBot.Message.Action.CameraRoll do
  @moduledoc """
  Represents a [Camera roll action](https://developers.line.biz/en/reference/messaging-api/#postback-action).
  """
  @derive Jason.Encoder
  @type t :: %__MODULE__{
          label: String.t(),
          type: :cameraRoll
        }
  @enforce_keys [:label]
  defstruct [:label, type: :cameraRoll]
end

defmodule LineBot.Message.Action.Location do
  @moduledoc """
  Represents a [Locaiton action](https://developers.line.biz/en/reference/messaging-api/#location-action).
  """
  @derive Jason.Encoder
  @type t :: %__MODULE__{
          label: String.t(),
          type: :location
        }
  @enforce_keys [:label]
  defstruct [:label, type: :location]
end
