defmodule LineBot.EventInfo do
  defstruct ~w(user_id source destination timestamp)a

  @moduledoc """
  This struct contains common metadata for each event that is passed to a `LineBot` event handler.
  """

  @typedoc """
  This struct contains common metadata for each event that is passed to a `LineBot` event handler.
  * `user_id` - The ID of the user that caused this event to be sent.  This information is
  extracted from the `source` object for convenience.
  * `source` - information about the message source. This corresponds  to the
  [source object](https://developers.line.biz/en/reference/messaging-api/#common-properties) of
  an event.
  * `destination` - the user ID of the bot that should receive the event. This corresponds to the
  [destination property](https://developers.line.biz/en/reference/messaging-api/#request-body)
  of the webhook request.
  * `timestamp` - a `DateTime` struct containing the time of the event. This corresponds  to the
  [timestamp property](https://developers.line.biz/en/reference/messaging-api/#request-body)
  of an event.
  """
  @type t :: %__MODULE__{
          user_id: String.t(),
          source: %{required(String.t()) => String.t()},
          destination: String.t(),
          timestamp: DateTime.t()
        }
end
