defmodule LineBot.MixProject do
  use Mix.Project

  @version "0.1.0"

  def project do
    [
      app: :line_bot,
      version: @version,
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      source_url: "https://github.com/adamu/line_bot",
      description: "A package for creating chatbots with the Line messenger",
      docs: docs()
    ]
  end

  defp package do
    [
      licenses: ["Apache 2.0"],
      links: %{
        "Messaging API Documentation" => "https://developers.line.biz/en/services/messaging-api/",
        "GitHub" => "https://github.com/adamu/line_bot",
        "Sample Bot" => "https://github.com/adamu/line_bot/tree/master/sample"
      }
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {LineBot.Application, []},
      extra_applications: [:logger]
    ]
  end

  defp docs do
    [
      main: "readme",
      extras: ["README.md"],
      source_ref: "v#{@version}",
      groups_for_modules: [
        LineBot: [
          LineBot,
          LineBot.APIClient,
          LineBot.EventInfo,
          LineBot.TokenServer,
          LineBot.Webhook
        ],
        Messages: [
          LineBot.Message,
          LineBot.Message.Text,
          LineBot.Message.Sticker,
          LineBot.Message.Image,
          LineBot.Message.Video,
          LineBot.Message.Audio,
          LineBot.Message.Location,
          LineBot.Message.Imagemap,
          LineBot.Message.Template,
          LineBot.Message.Flex,
          LineBot.Message.QuickReply,
          LineBot.Message.QuickReplyItem
        ],
        Actions: [
          LineBot.Message.Action,
          LineBot.Message.Action.Postback,
          LineBot.Message.Action.Message,
          LineBot.Message.Action.URI,
          LineBot.Message.Action.DateTimePicker,
          LineBot.Message.Action.Camera,
          LineBot.Message.Action.CameraRoll,
          LineBot.Message.Action.Location
        ],
        "Flex Message": [
          LineBot.Message.Flex.Carousel,
          LineBot.Message.Flex.Bubble,
          LineBot.Message.Flex.BubbleStyle,
          LineBot.Message.Flex.BubbleStyleBlock,
          LineBot.Message.Flex.Box,
          LineBot.Message.Flex.Button,
          LineBot.Message.Flex.Filler,
          LineBot.Message.Flex.Icon,
          LineBot.Message.Flex.Image,
          LineBot.Message.Flex.Separator,
          LineBot.Message.Flex.Spacer,
          LineBot.Message.Flex.Text
        ],
        Imagemap: [
          LineBot.Message.Imagemap.BaseSize,
          LineBot.Message.Imagemap.Video,
          LineBot.Message.Imagemap.Video.ExternalLink,
          LineBot.Message.Imagemap.Area,
          LineBot.Message.Imagemap.Action.Message,
          LineBot.Message.Imagemap.Action.URI
        ],
        Template: [
          LineBot.Message.Template.Buttons,
          LineBot.Message.Template.Confirm,
          LineBot.Message.Template.Carousel,
          LineBot.Message.Template.Carousel.Column,
          LineBot.Message.Template.Column,
          LineBot.Message.Template.ImageCarousel,
          LineBot.Message.Template.ImageCarousel.Column
        ]
      ]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:plug, "~> 1.8"},
      {:httpoison, "~> 1.5"},
      {:jason, "~> 1.1"},
      {:ex_doc, "~> 0.21", only: :dev, runtime: false},
      {:dialyxir, "~> 0.5", only: :dev, runtime: false},
      {:mox, "~> 0.5", only: :test}
    ]
  end
end
