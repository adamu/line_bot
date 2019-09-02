# Line Bot

This package provides the basic framework required to implement and run a Line Bot.

There are two main modules in this package:

1. `LineBot` provides helpers to call the various APIs, for example `LineBot.send_reply/3` to reply to an event. This module also defines callbacks for you to implement, which are called when your bot receives events from the Line server.
2. `LineBot.Webhook` provides a `Plug` for handling HTTP requests from the line server, and forwarding them to your callback module, which should implement the `LineBot` behaviour.

## Installation

Add `:line_bot` to your mix deps:

```elixir
defp deps do
  [
    {:line_bot, path: "../"}
  ]
end
```

## Features

1. Defines callbacks (see `LineBot`) to handle all of the possible [events](https://developers.line.biz/en/reference/messaging-api/#webhook-event-objects) a bot can receive.
1. Provides a plug (`LineBot.Webhook`) to automatically verify, decode, and dispatch webhook requests a bot received.
1. Provides API helpers (see `LineBot`) for all of the documented Messaging API endpoints.
   * Automatically retrieves, maintains, renews, and injects the access token into API requests a bot makes.
   * When necessary, automatically handles encoding and decoding of JSON and adding the required HTTP headers.
1. Defines structs for all of the available message types, to allow for compile-time checking. See `LineBot.Message`.


## Getting Started

### 1. Configure OAuth credentials for your bot.

Credentials are available from the [Line Developers](https://developers.line.biz/) site. The credentials are called `Channel ID` and `Channel secret` on the developers site.

In `config/config.exs`:

```elixir
import Config
config :line_bot,
  client_id: YOUR_CHANNEL_ID
  client_secret: YOUR_CHANNEL_SECRET
```

### 2. Create a module that implements the `LineBot` behaviour to handle callbacks.

The recommended way to do this is to `use LineBot`, which will create default callbacks handlers, and then override the events you want to handle. The default implementations return without doing anything.

An example is available in the [sample application](../sample/lib/line_bot_sample.ex).

### 3. Forward webhook requests to `LineBot.Webhook`, and tell it your callback module.

Using `Plug.Router`, this can be done as follows:

```elixir
forward "/bot", to: LineBot.Webhook, callback: YourCallbackModule
```

The forwarded URL should be whatever you specified as the callback URI on the Line Developers site.

For detailed instructions, see `LineBot.Webhook`. You can also check the [sample application](../sample/lib/line_bot_sample/router.ex).

## Not supported

The [Rich Menu API](https://developers.line.biz/en/reference/messaging-api/#rich-menu) is not currently implemented, although `LineBot.APIClient` can be used to call the API manually.

For example, you can post to the rich menu API like this:

```elixir
menu = %{
  "areas" => [
    %{
      "action" => %LineBot.Message.Action.URI{uri: "http://example.com"},
      "bounds" => %{"height" => 1686, "width" => 2500, "x" => 0, "y" => 0}
    }
  ],
  "chatBarText" => "test",
  "name" => "test",
  "selected" => false,
  "size" => %{"height" => 1686, "width" => 2500}
}
LineBot.APIClient.post("richmenu", menu)
```

And get like this:

```elixir
LineBot.APIClient.get("richmenu/list")
```

## TODO

* [ ] Tests
* [ ] Static resources
* [ ] Update post-publish sample links.
