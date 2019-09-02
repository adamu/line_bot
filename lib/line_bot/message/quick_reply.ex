defmodule LineBot.Message.QuickReply do
  @derive Jason.Encoder

  @moduledoc """
  Represents a [Quick reply](https://developers.line.biz/en/reference/messaging-api/#quick-reply) object.
  """
  @type t :: %__MODULE__{
          items: [LineBot.Message.QuickReplyItem.t()]
        }
  @enforce_keys [:items]
  defstruct [:items]
end

defmodule LineBot.Message.QuickReplyItem do
  use LineBot.Message

  @moduledoc """
  Represents a [Quick reply button](https://developers.line.biz/en/reference/messaging-api/#quick-reply-button-object) object.
  """
  @type t :: %__MODULE__{
          imageUrl: String.t(),
          action: LineBot.Message.Action.t(),
          type: :action
        }
  @enforce_keys [:action]
  defstruct [:imageUrl, :action, type: :action]
end
